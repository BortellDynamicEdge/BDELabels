page 50102 BDEAssemblyPage
{
    ApplicationArea = All;
    Caption = 'BDE Assembly';
    PageType = Card;
    SourceTable = BDEAssemblyHeader;
    DelayedInsert = false;

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
                field("Usage Type"; Rec."Item Usage Type")
                {
                    ToolTip = 'Specifies the Item Usage Type.';
                }
                field("Quantity"; Rec."Quantity")
                {
                    Caption = 'Quantity/Weight';
                    ToolTip = 'Specifies the Quantity Used.';
                }
                field("Production Quantity"; Rec."Production Quantity")
                {
                    ToolTip = 'The Production Quantity for the operation.';
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
                begin
                    if (ProductionDate = 0D) then
                        Message('Please select a production date.')
                    else
                        PostAssembly(ProductionDate);
                end;
            }
        }
    }
    var
        BOM: Record BDEAssemblyHeader;
        ProductionDate: Date;

    trigger OnOpenPage()
    begin
        ProductionDate := Today();  // default production date to today
    end;

    procedure PostAssembly(prodDate: Date)
    var
        itembatch: Record "Item Journal Batch";
        assemblyline: Record BDEAssemblyLines;
        TotalCost: Decimal;
    begin
        journaltemplate := 'ITEM';
        batchname := 'ASSEMBLY';
        linenumber := 0;
        lotnumber := FORMAT(prodDate, 0, '<Year4><Month,2><Day,2>');

        itembatch.Init();
        itembatch."Journal Template Name" := journaltemplate;
        itembatch.Name := batchname;
        if not itembatch.Get(itembatch."Journal Template Name", itembatch.Name) then begin
            //itemjournalbatch."Item Tracking on Lines" := 1;
            itembatch.Insert();
            itembatch.Modify(true);
        end;


        assemblyline.Init();
        assemblyline.Reset();
        assemblyline.SetRange("Assembly No.", Rec."Assembly No.");
        TotalCost := 0;

        // If assembly then lines are negative and header is positive
        if Rec."Assembly Type " = BDEAssemblyType::"Assembly" then
            sourcetype := 1
        else
            sourcetype := 2;

        if (assemblyline.FindSet()) then begin
            // Initialise ledger entry defaults

            repeat
                CreateJournalLine(assemblyline."Item No", assemblyline.UofM, assemblyline.Quantity * Rec."Production Quantity", assemblyline."Unit Cost" + assemblyline."Labour Cost", prodDate);
            until (assemblyline.Next() = 0);

            // If assembly then lines are negative and header is positive
            if Rec."Assembly Type " = BDEAssemblyType::"Assembly" then
                sourcetype := 2
            else
                sourcetype := 1;
            CreateJournalLine(Rec."Item Number", Rec."UofM", Rec."Quantity" * Rec."Production Quantity", assemblyline."Unit Cost" + assemblyline."Labour Cost", prodDate);
        end;
    end;

    procedure CreateJournalLine(itemno: code[20]; uofm: code[10]; quantity: Decimal; cost: Decimal; prodDate: Date)
    var
        item: Record Item;
        itemuofm: Record "Item Unit of Measure";
        itemline: Record "Item Journal Line";
        qtybase: Decimal;
        coysetup: Record "Company Information";

    begin
        if not coysetup.Get() then
            Error('Inventorysetup Missing');
        locationcode := coysetup."Location Code";
        if not item.Get(itemno) then
            Error('Item Number Missing');
        if not itemuofm.Get(itemno, uofm) then
            Error('Item Unit of measure missing');

        itemline."Journal Template Name" := journaltemplate;
        itemline."Journal Batch Name" := batchname;
        itemline."Document No." := 'MGTEST';

        // Only get the line seq for the first time as the new records are in a buffer and dont get committed untill the end of the process
        if linenumber = 0 then
            GetLineNumber()
        else
            linenumber += 10000;
        itemline."Line No." := linenumber;
        itemline.Insert();
        //itemline."Line No." := assemblyline."Line No.";
        itemline."Item No." := itemno;
        itemline."Unit of Measure Code" := uofm;
        itemline."Posting Date" := prodDate;
        itemline."Document Date" := prodDate;

        // sourcetype 1 = Negative  Adjustment , 2 =  Postitive Adjustment used to differentiate header and line 
        if sourcetype = 1 then begin
            itemline."Entry Type" := "Item Ledger Entry Type"::"Negative Adjmt.";
            itemline.Type := "Capacity Type Journal"::" ";
        end
        else begin
            itemline."Entry Type" := "Item Ledger Entry Type"::"Positive Adjmt.";
            itemline.Type := "Capacity Type Journal"::" ";
        end;
        itemline.Description := item.Description;
        itemline."Location Code" := locationcode;
        itemline."Inventory Posting Group" := item."Inventory Posting Group";
        itemline."Qty. per Unit of Measure" := itemuofm."Qty. per Unit of Measure";
        qtybase := quantity * itemuofm."Qty. per Unit of Measure";
        itemline.Quantity := quantity;
        itemline."Quantity (Base)" := qtybase;
        itemline."Invoiced Quantity" := quantity;
        itemline."Invoiced Qty. (Base)" := qtybase;
        itemline."Unit Amount" := cost;
        itemline."Unit Cost" := cost;
        itemline.Amount := cost * quantity;
        itemline."Source Code" := 'ITEMJNL';
        //itemline."Source Type" := "Analysis Source Type"::Item;
        itemline."Gen. Prod. Posting Group" := item."Gen. Prod. Posting Group";

        //itemline."Lot No." := lotnumber;
        itemline.Modify(true);
        if item."Item Tracking Code" <> '' then
            CreateReservationEntry(itemline."Item No.", quantity, qtybase, itemuofm."Qty. per Unit of Measure", prodDate);
    end;

    procedure GetLineNumber()
    var
        journalline: Record "Item Journal Line";

    begin
        journalline.Reset();
        journalline.SetRange("Journal Template Name", journaltemplate);
        journalline.SetRange("Journal Batch Name", batchname);
        if (journalline.FindLast()) then
            linenumber := journalline."Line No." + 10000
        else
            linenumber := 10000;

    end;

    procedure CreateReservationEntry(item: code[20]; qty: Decimal; qtybase: Decimal; qtyuofm: Decimal; prodDate: Date)
    var
        reservation: Record "Reservation Entry";
    begin
        reservation."Entry No." := reservation.GetLastEntryNo() + 1;
        // 1 = negative adjustment , 2= positive adjustment
        if sourcetype = 1 then begin
            reservation.Positive := false;
            reservation."Source Subtype" := 3;
            reservation."Shipment Date" := prodDate;
            reservation."Quantity (Base)" := -qtybase;
            reservation.Quantity := -qty;
            reservation."Qty. to Handle (Base)" := -qtybase;
            reservation."Qty. to Invoice (Base)" := -qtybase;
        end
        else begin
            reservation.Positive := true;
            reservation."Source Subtype" := 2;
            reservation."Quantity (Base)" := qtybase;
            reservation."Expected Receipt Date" := prodDate;
            reservation.Quantity := qty;
            reservation."Qty. to Handle (Base)" := qtybase;
            reservation."Qty. to Invoice (Base)" := qtybase;
        end;
        reservation.Insert();
        reservation."Qty. per Unit of Measure" := qtyuofm;
        reservation."Item No." := item;
        reservation."Location Code" := locationcode;
        reservation."Item Tracking" := "Item Tracking Entry Type"::"Lot No.";
        reservation."Lot No." := lotnumber;
        reservation."Reservation Status" := "Reservation Status"::Prospect;
        reservation."Creation Date" := prodDate;
        reservation."Source Type" := 83;
        reservation."Source ID" := journaltemplate;
        reservation."Source Batch Name" := batchname;
        reservation."Source Ref. No." := linenumber;
        reservation."Expected Receipt Date" := prodDate;

        if not reservation.Modify(true) then
            Error('Failed to write reservation entry');
    end;

    var
        journaltemplate: code[20];
        batchname: code[20];
        linenumber: Integer;
        sourcetype: Integer;
        locationcode: code[20];
        lotnumber: code[50];
}
