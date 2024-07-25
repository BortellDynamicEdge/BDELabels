page 50102 BDEAssemblyPage
{
    ApplicationArea = All;
    Caption = 'BDE Assembly';
    PageType = Card;
    SourceTable = BDEAssemblyHeader;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("BOM No."; Rec."Assembly No.")
                {
                    ToolTip = 'The unique identifier for the operation.';
                }
                field("Type"; Rec."Assembly Type ")
                {
                    ToolTip = 'Specifies the type of assembly.';
                }
                field("Description"; Rec."Assembly Description")
                {
                    ToolTip = 'Description for the (dis)assembly operation.';
                }
                field("Item Number"; Rec."Item Number")
                {
                    Lookup = true;
                    LookupPageId = "Item Lookup";
                    ToolTip = 'Specifies the Item Number.';
                }
                field("Unit"; Rec."UofM")
                {
                    ToolTip = 'Specifies the Unit of Measure.';
                }
                // field("Usage Type"; Rec."Item Usage Type")
                // {
                //     ToolTip = 'Specifies the Item Usage Type.';
                // }
                field("Quantity"; Rec."Quantity")
                {
                    Caption = 'Quantity/Weight';
                    ToolTip = 'Specifies the Quantity Used.';
                }
                field("Item Cost"; Rec."Item Cost")
                {
                    ToolTip = 'Specifies the value of the Item Cost field.';
                }

            }
            group("Run Data")
            {
                field("Production Date"; ProductionDate)
                {
                    ApplicationArea = All;
                    Caption = 'Production Date';
                    NotBlank = true;
                    Tooltip = 'Specifies the date on which the production occurred.';
                }

                // field("Lot Entry"; ItemLedgerEntryId)
                // {
                //     Lookup = true;
                //     TableRelation = "Item Ledger Entry" WHERE("Item No." = Field("Item Number"), "Open" = const(true), "Entry Type" = Const("Item Ledger Entry Type"::"Positive Adjmt."));

                //     trigger OnAfterLookup(Selected: RecordRef)
                //     var
                //         entry: Record "Item Ledger Entry";
                //     begin
                //         Selected.SetTable(entry);
                //         Lot := entry."Lot No.";
                //     end;
                // }

                field("Lot #"; ProductionLotNumber)
                {
                    ApplicationArea = All;
                    NotBlank = true;
                    ToolTip = 'The lot number for created items.';
                }
                field("Production Quantity"; ProductionQuantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'The Production Quantity for the operation.';
                }
            }
            part(BOMGrid; "BDEAssemblySubform")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Assembly No." = FIELD("Assembly No.");
                UpdatePropagation = Both;
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'Post';

                trigger OnAction();
                var
                    CreatedDocumentNumber: Code[20];
                begin
                    if (ProductionDate = 0D) then
                        Message('Please select a production date.')
                    else if (ProductionQuantity <= 0) then
                        Message('Please enter a production quantity greater than zero.')
                    else begin
                        AutoGenerateAssemblyLots();
                        CreatedDocumentNumber := PostAssembly(ProductionDate);
                        Message('Created document "%1".', CreatedDocumentNumber);
                    end
                end;
            }

            action(TestAllocation)
            {
                ApplicationArea = All;
                Caption = 'Test Allocation';

                trigger OnAction()
                begin
                    if (ProductionQuantity <= 0) then
                        Message('Please enter a production quantity greater than zero.')
                    else begin
                        AutoGenerateAssemblyLots();
                        Message('Test Allocation operation completed successfully.');
                    end;
                end;
            }
        }
    }

    var
        BatchName: code[20];
        BOM: Record BDEAssemblyHeader;
        ItemLedgerEntryId: Integer;
        JournalTemplate: code[20];
        LineNumber: Integer;
        LocationCode: code[20];
        LotAllocations: Record "BDE Assembly Lot" temporary;
        ProductionDate: Date;
        ProductionLotNumber: code[50];
        ProductionQuantity: Decimal;
        SourceType: Integer;

    trigger OnOpenPage()
    begin
        ProductionDate := Today();  // default production date to today
        Clear(ProductionLotNumber);
        Clear(ProductionQuantity);
        ProductionLotNumber := FORMAT(ProductionDate, 0, '<Year4><Month,2><Day,2>');
    end;

    // auto-generates proposed assembly lot allocations based on current page data
    local procedure AutoGenerateAssemblyLots()
    begin
        Rec.TestField(Rec."Assembly No.");                              // ensure we have a value for assembly no.
        ClearAssemblyLots(Rec."Assembly No.");                          // remove any existing lot suggestions for the assembly

        if (Rec."Assembly Type " = BDEAssemblyType::Assembly) then
            CreateAssemblyLots()                                        // generate assembly lot assignments for the the line items being used to create the new item
        else if (Rec."Assembly Type " = BDEAssemblyType::"Dis-Assembly") then
            CreateDisassemblyLots()
    end;

    // clears all current assembly lot records for a given assembly record
    local procedure ClearAssemblyLots(AssemblyNo: Code[20])
    begin
        LotAllocations.Reset();
        LotAllocations.SetRange("Assembly No.", AssemblyNo);
        if (LotAllocations.FindSet()) then
            LotAllocations.DeleteAll();
    end;

    // inserts data into BDE Assembly Lot table for consumption of items used to make up an assembly based on the current page data (e.g. breast => schnitzel)
    local procedure CreateAssemblyLots()
    var
        AssemblyLines: Record BDEAssemblyLines;
        Item: Record Item;
        ItemUofM: Record "Item Unit of Measure";
        QuantityRequired: Decimal;
    begin
        SetAssemblyLinesFilter(Rec."Assembly No.", AssemblyLines);       // configure assembly line retrieval
        if (AssemblyLines.FindSet()) then begin
            repeat
                if not Item.Get(AssemblyLines."Item No") then
                    Error('Unable to retrieve details for item "%1".', AssemblyLines."Item No");
                if not ItemUofM.Get(AssemblyLines."Item No", AssemblyLines.UofM) then
                    Error('Unable to retrieve unit of measure information for item "%1".', AssemblyLines."Item No");

                if (Item."Item Tracking Code" <> '') and (AssemblyLines."Total Quantity" <> 0) then begin                                                                 // only attempt to find lot numbers if the item has some sort of item tracking specified
                    QuantityRequired := (AssemblyLines."Total Quantity" * ItemUofM."Qty. per Unit of Measure");    // convert from requested unit to quantity in base UoM as this is what is stored in the item ledger entry table
                    if not CreateLotAllocation(AssemblyLines."Assembly No.", AssemblyLines."Line No.", AssemblyLines."Item No", QuantityRequired) then begin
                        Error('Unable to allocate lots for item "%1".', AssemblyLines."Item No");
                        ClearAssemblyLots(Rec."Assembly No.");
                        exit;
                    end;
                end;
            until AssemblyLines.Next() = 0;
        end;
    end;

    // inserts data into BDE Assembly Lot table for consumption of the primary item being broken up to create one or more production items (e.g. whole chicken => wing, breast, thigh, etc.)
    local procedure CreateDisassemblyLots()
    var
        Item: Record Item;
        ItemUofM: Record "Item Unit of Measure";
        QuantityRequired: decimal;
    begin
        if not Item.Get(Rec."Item Number") then
            Error('Unable to retrieve details for item "%1".', Rec."Item Number");
        if not ItemUofM.Get(Rec."Item Number", Rec.UofM) then
            Error('Unable to retrieve unit of measure information for item "%1".', Rec."Item Number");

        if (Item."Item Tracking Code" = '') then        // only attempt to find lot numbers if the item has some sort of item tracking specified
            exit;

        QuantityRequired := (Rec.Quantity * ItemUofM."Qty. per Unit of Measure") * ProductionQuantity;      // calculate total quantity in base UoM of the item we need to break down to fulfil the specified production operation
        if not CreateLotAllocation(Rec."Assembly No.", 0, Rec."Item Number", QuantityRequired) then begin
            Error('Unable to allocate lots for item "%1".', Rec."Item Number");
            ClearAssemblyLots(Rec."Assembly No.");
            exit;
        end;
    end;

    local procedure CreateJournalLine(DocumentNo: Code[20]; AssemblyLineNo: Integer; ItemNo: code[20]; UnitOfMeasure: code[10]; Quantity: Decimal; Cost: Decimal; ProductionDate: Date)
    var
        CompanySetup: Record "Company Information";
        Item: Record Item;
        ItemLedgerEntryId: Integer;
        ItemLine: Record "Item Journal Line";
        ItemUofM: Record "Item Unit of Measure";
        LotNumber: Code[50];
        QtyBase: Decimal;
    begin
        if not CompanySetup.Get() then
            Error('Inventorysetup Missing');
        LocationCode := CompanySetup."Location Code";
        if not Item.Get(ItemNo) then
            Error('Item Number Missing');
        if not ItemUofM.Get(ItemNo, UnitOfMeasure) then
            Error('Item Unit of measure missing');

        ItemLine."Journal Template Name" := JournalTemplate;
        ItemLine."Journal Batch Name" := BatchName;
        ItemLine."Document No." := DocumentNo;
        ItemLine."External Document No." := Rec."Assembly No.";

        // Only get the line seq for the first time as the new records are in a buffer and dont get committed untill the end of the process
        if LineNumber = 0 then
            GetLineNumber()
        else
            LineNumber += 10000;
        ItemLine."Line No." := LineNumber;
        ItemLine.Insert();
        //itemline."Line No." := assemblyline."Line No.";
        ItemLine."Item No." := ItemNo;
        ItemLine."Unit of Measure Code" := UnitOfMeasure;
        ItemLine."Posting Date" := ProductionDate;
        ItemLine."Document Date" := ProductionDate;

        // sourcetype 1 = Negative  Adjustment , 2 =  Postitive Adjustment used to differentiate header and line 
        if SourceType = 1 then begin
            ItemLine."Entry Type" := "Item Ledger Entry Type"::"Negative Adjmt.";
            ItemLine.Type := "Capacity Type Journal"::" ";
        end
        else begin
            ItemLine."Entry Type" := "Item Ledger Entry Type"::"Positive Adjmt.";
            ItemLine.Type := "Capacity Type Journal"::" ";
            if (Item."Item Tracking Code" <> '') then
                ItemLine."Expiration Date" := CalcDate(item."Expiration Calculation", ProductionDate);
        end;
        ItemLine.Description := Item.Description;
        ItemLine."Location Code" := LocationCode;
        ItemLine."Inventory Posting Group" := Item."Inventory Posting Group";
        ItemLine."Qty. per Unit of Measure" := ItemUofM."Qty. per Unit of Measure";
        QtyBase := Quantity * ItemUofM."Qty. per Unit of Measure";
        ItemLine.Quantity := Quantity;
        ItemLine."Quantity (Base)" := QtyBase;
        ItemLine."Invoiced Quantity" := Quantity;
        ItemLine."Invoiced Qty. (Base)" := QtyBase;
        ItemLine."Unit Amount" := Cost;
        ItemLine."Unit Cost" := Cost;
        ItemLine.Amount := Cost * Quantity;
        ItemLine."Source Code" := 'ITEMJNL';
        //itemline."Source Type" := "Analysis Source Type"::Item;
        ItemLine."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";



        //itemline."Lot No." := lotnumber;
        ItemLine.Modify(true);

        if (SourceType = 1) and (Item."Item Tracking Code" <> '') then begin        // consumption of items should use the lot numbers found during the setup stage of the opertation
            LotAllocations.SetRange("Assembly No.", Rec."Assembly No.");
            LotAllocations.SetRange("Line No.", AssemblyLineNo);
            if (LotAllocations.FindFirst()) then begin
                ItemLedgerEntryId := LotAllocations."Item Ledger Entry No.";
                LotNumber := LotAllocations."Lot No.";
            end;
        end
        else if (SourceType = 2) and (Item."Item Tracking Code" <> '') then         // creation of items that require lot tracking always use the lot number specified on the page
            LotNumber := ProductionLotNumber;

        if LotNumber <> '' then
            CreateReservationEntry(ItemLine."Item No.", Quantity, QtyBase, ItemUofM."Qty. per Unit of Measure", ProductionDate, LotNumber, ItemLedgerEntryId);
        // if Item."Item Tracking Code" <> '' then
        //     CreateReservationEntry(ItemLine."Item No.", Quantity, QtyBase, ItemUofM."Qty. per Unit of Measure", ProductionDate);        
    end;

    // inserts data into BDE Assembly Lot table for a given item.
    // returns true if the Quantity requested was allocated, else false 
    local procedure CreateLotAllocation(AssemblyNo: Code[20]; LineNo: Integer; ItemNo: Code[20]; Quantity: Decimal): Boolean
    var
        AvailableLots: Record "Item Ledger Entry";
        QuantityUnassigned: Decimal;
        QuantityToAssign: Decimal;
    begin
        QuantityUnassigned := Quantity;                                     // need to keep track of how many are left to assign
        SetAvailableLotsFilter(ItemNo, AvailableLots);                      // configure filter to retrieve lot data
        if AvailableLots.FindSet() then begin
            repeat
                // check available quantity and assign as much as possible to the disassembly item until we no longer need to assign
                if (QuantityUnassigned > 0) then begin
                    QuantityToAssign := 0;
                    if (AvailableLots."Remaining Quantity" >= QuantityUnassigned) then
                        QuantityToAssign := QuantityUnassigned
                    else
                        QuantityToAssign := AvailableLots."Remaining Quantity";

                    if (QuantityToAssign > 0) then begin                    // if we have found a quantity to assign from the current lot record, insert an allocation record
                        LotAllocations.Init();
                        LotAllocations.Validate("Assembly No.", AssemblyNo);
                        LotAllocations.Validate("Line No.", LineNo);
                        LotAllocations.Validate("Item Ledger Entry No.", AvailableLots."Entry No.");
                        LotAllocations.Validate("Item No.", AvailableLots."Item No.");
                        LotAllocations.Validate("Lot No.", AvailableLots."Lot No.");
                        LotAllocations.Validate(Quantity, QuantityToAssign);

                        if (LotAllocations.Insert()) then
                            QuantityUnassigned -= QuantityToAssign;         // keep track of the quantity for which lots still need to be allocated

                        if (QuantityUnassigned <= 0) then
                            break;                                          // fully allocated so break out of the repeat...until loop
                    end;
                end;
            until AvailableLots.Next() = 0;
        end;

        exit(QuantityUnassigned = 0);
    end;

    local procedure CreateReservationEntry(ItemNo: code[20]; Quantity: Decimal; QuantityBase: Decimal; QuantityPerUofM: Decimal; ProductionDate: Date; LotNumber: Code[50]; ItemLedgerEntryId: Integer)
    var
        Reservation: Record "Reservation Entry";
    begin
        Reservation."Entry No." := Reservation.GetLastEntryNo() + 1;
        // 1 = negative adjustment , 2= positive adjustment
        if SourceType = 1 then begin
            Reservation."Appl.-to Item Entry" := ItemLedgerEntryId;
            Reservation.Positive := false;
            Reservation."Source Subtype" := 3;
            Reservation."Shipment Date" := ProductionDate;
            Reservation."Quantity (Base)" := -QuantityBase;
            Reservation.Quantity := -Quantity;
            Reservation."Qty. to Handle (Base)" := -QuantityBase;
            Reservation."Qty. to Invoice (Base)" := -QuantityBase;
        end
        else begin
            Reservation.Positive := true;
            Reservation."Source Subtype" := 2;
            Reservation."Quantity (Base)" := QuantityBase;
            Reservation."Expected Receipt Date" := ProductionDate;
            Reservation.Quantity := Quantity;
            Reservation."Qty. to Handle (Base)" := QuantityBase;
            Reservation."Qty. to Invoice (Base)" := QuantityBase;
        end;
        Reservation.Insert();
        Reservation."Qty. per Unit of Measure" := QuantityPerUofM;
        Reservation."Item No." := ItemNo;
        Reservation."Location Code" := LocationCode;
        Reservation."Item Tracking" := "Item Tracking Entry Type"::"Lot No.";
        Reservation."Lot No." := LotNumber;
        Reservation."Reservation Status" := "Reservation Status"::Prospect;
        Reservation."Creation Date" := ProductionDate;
        Reservation."Source Type" := 83;
        Reservation."Source ID" := JournalTemplate;
        Reservation."Source Batch Name" := BatchName;
        Reservation."Source Ref. No." := LineNumber;
        Reservation."Expected Receipt Date" := ProductionDate;

        if not Reservation.Modify(true) then
            Error('Failed to write reservation entry');
    end;

    local procedure GetLineNumber()
    var
        JournalLine: Record "Item Journal Line";
    begin
        JournalLine.Reset();
        JournalLine.SetRange("Journal Template Name", JournalTemplate);
        JournalLine.SetRange("Journal Batch Name", BatchName);
        if (JournalLine.FindLast()) then
            LineNumber := JournalLine."Line No." + 10000
        else
            LineNumber := 10000;

    end;

    local procedure PostAssembly(ProductionDate: Date): Code[20]
    var
        AssemblyLine: Record BDEAssemblyLines;
        DocumentNo: Code[20];
        ItemJournalBatch: Record "Item Journal Batch";
        NoMgt: Codeunit NoSeriesManagement;
        TotalCost: Decimal;
    //ivpost: Codeunit "Item Jnl.-Post Batch";

    begin
        JournalTemplate := 'ITEM';
        BatchName := 'ASSEMBLY';
        LineNumber := 0;
        //LotNumber := FORMAT(ProductionDate, 0, '<Year4><Month,2><Day,2>');

        ItemJournalBatch.Init();
        ItemJournalBatch."Journal Template Name" := JournalTemplate;
        ItemJournalBatch.Name := BatchName;
        if not ItemJournalBatch.Get(ItemJournalBatch."Journal Template Name", ItemJournalBatch.Name) then begin
            //itemjournalbatch."Item Tracking on Lines" := 1;
            ItemJournalBatch.Insert();
            ItemJournalBatch.Modify(true);
        end;

        // if not ItemJournalBatch.Get(BatchName) then
        //     Error('Item Journal Batch "%1" not been configured.', BatchName);

        ItemJournalBatch.TestField("No. Series");                                           // ensure there is a number series specified on the target batch
        DocumentNo := NoMgt.GetNextNo(ItemJournalBatch."No. Series", WorkDate(), true);     // get next number from the number series configured on the target batch        

        AssemblyLine.Init();
        AssemblyLine.Reset();
        AssemblyLine.SetRange("Assembly No.", Rec."Assembly No.");
        TotalCost := 0;

        // If assembly then lines are negative and header is positive
        if Rec."Assembly Type " = BDEAssemblyType::"Assembly" then
            SourceType := 1
        else
            SourceType := 2;

        if (AssemblyLine.FindSet()) then begin
            // create journal lines for each assembly line
            repeat
                CreateJournalLine(DocumentNo, AssemblyLine."Line No.", AssemblyLine."Item No", AssemblyLine.UofM, AssemblyLine."Total Quantity", AssemblyLine."Unit Cost" + AssemblyLine."Labour Cost", ProductionDate);
            until (AssemblyLine.Next() = 0);

            // If assembly then lines are negative and header is positive
            if Rec."Assembly Type " = BDEAssemblyType::"Assembly" then
                SourceType := 2
            else
                SourceType := 1;
            CreateJournalLine(DocumentNo, 0, Rec."Item Number", Rec."UofM", Rec."Quantity" * ProductionQuantity, AssemblyLine."Unit Cost" + AssemblyLine."Labour Cost", ProductionDate);
            exit(DocumentNo);
        end
        else
            Error('Template "%1" does not define any assembly lines.', Rec."Assembly No.");
    end;


    // configures the filters required to retrieve assembly line data for a given assembly number.
    local procedure SetAssemblyLinesFilter(AssemblyNo: Code[20]; var AssemblyLines: Record BDEAssemblyLines)
    begin
        AssemblyLines.Reset();
        AssemblyLines.SetRange("Assembly No.", AssemblyNo);
    end;

    // configures the filters required to retrieve available lot data for a given item number
    local procedure SetAvailableLotsFilter(ItemNo: Code[20]; var Lots: Record "Item Ledger Entry")
    begin
        Lots.Reset();
        //Lots.SetCurrentKey("Item No.", "Posting Date");   // may want to sort by posting date to get older entries first
        Lots.SetFilter("Entry Type", '%1|%2', "Item Ledger Entry Type"::"Positive Adjmt.", "Item Ledger Entry Type"::Purchase);
        Lots.SetRange("Item No.", ItemNo);
        Lots.SetRange(Open, true);
        Lots.SetLoadFields("Entry No.", "Entry Type", "Item No.", "Remaining Quantity", "Unit of Measure Code");    // reduce fields retrieved to only those required for processing
    end;
}
