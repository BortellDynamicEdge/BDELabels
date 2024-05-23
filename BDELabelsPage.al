page 50100 "BDE Labels"
//page 70389540 "BDE Labels"
{
    Caption = 'BDE Labels';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = BDELabelHeader;
    // SourceTableView = WHERE("Document Type" = FILTER(Order));

    // AboutTitle = 'About sales order details';
    // AboutText = 'Choose the order details and fill in order lines with quantities of what you are selling. Post the order when you are ready to ship or invoice. This creates posted sales shipments and posted sales invoices.';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Caption = 'Document Type';

                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Caption = 'Document Number';

                }
                field("Customer Name"; Rec.CustomerName)
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                }
                field("Purchase Order Number"; Rec.Reference)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Order Number';
                }



                field("Total Cartons"; Rec.OrderCartonCount)
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Caption = 'Total Cartons';

                }
            }
            part(LabelsGrid; "BDELabelsSubform")
            {
                ApplicationArea = Basic, Suite;
                // Editable = IsSalesLinesEditable;
                //Enabled = IsSalesLinesEditable;
                SubPageLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("Document No.");

                UpdatePropagation = Both;
            }

        }
    }

    actions
    {

        area(Processing)
        {

            //group(Labels)
            //{
            //    Caption = 'Labels';

            action(Generate)
            {
                ApplicationArea = All;
                Caption = 'Generate';

                trigger OnAction();
                begin
                    DeleteLabels();
                    Generatelbls();
                end;
            }
            action(Print)
            {
                ApplicationArea = All;
                Caption = 'Print';
                InFooterBar = true;

                trigger OnAction();
                begin
                    labelreport.SetParameters(Rec."Document No.");
                    labelreport.RunModal();
                    Clear(labelreport);
                end;
            }

            action(Cartons)
            {
                ApplicationArea = All;
                Caption = 'Carton Sizes';

                trigger OnAction();
                begin

                    cartpage.RunModal();
                end;
            }

            //}
        }
    }


    trigger OnAfterGetRecord()
    begin
        label.Reset();
        label.SetRange("Document Type", Rec."Document Type");
        label.SetRange("Document No.", Rec."Document No.");
        if (label.FindSet() = false) then begin
            Generatelbls();
        end;
    end;

    var
        saleslines: Record "Sales Line";
        item: Record Item;

        label: Record BDELabelLines;

        lblheader: Record BDELabelHeader;

        lblcartons: Record BDELabelCartons;

        cartpage: Page BDELabelCartons;

        currentline: Integer;
        currentcount: Integer;
        totalcount: Integer;
        itemcartons: Integer;
        itemexists: Boolean;

        ok: Boolean;
        itemloop: Integer;

        CartonSize: Integer;

        labelsallocated: Decimal;

        labelreport: Report BDELabelsReport;

        lblpage: Page "BDE Labels";

    procedure DeleteLabels()
    begin
        // Remove all records before generating labels
        label.Reset();
        label.SetRange("Document Type", Rec."Document Type");
        label.SetRange("Document No.", Rec."Document No.");
        label.DeleteAll();
    end;

    procedure GenerateCartons()
    begin
        // Remove all records before generating labels
        lblcartons.Reset();
        lblcartons.SetRange("Document Type", Rec."Document Type");
        lblcartons.SetRange("Document No.", Rec."Document No.");
        if (lblcartons.FindSet() = false) then begin
            saleslines.Reset();
            saleslines.SetRange("Document Type", Rec."Document Type");
            saleslines.SetRange("Document No.", Rec."Document No.");
            if (saleslines.FindSet()) then begin
                repeat
                    item.Get(saleslines."No.");
                    CartonSize := 1;

                    if item."Order Multiple" <> 0 then begin
                        CartonSize := item."Order Multiple";
                    end;

                    lblcartons.Init();
                    lblcartons."Document Type" := Rec."Document Type";
                    lblcartons."Document No." := Rec."Document No.";
                    lblcartons."Line No." := saleslines."Line No.";
                    lblcartons.CartonSize := CartonSize;
                    lblcartons.Insert();
                until (saleslines.Next() = 0);
            end;
        end;
    end;

    procedure Generatelbls()
    begin
        GenerateCartons();
        DeleteLabels();
        saleslines.Reset();
        saleslines.SetRange("Document Type", Rec."Document Type");
        saleslines.SetRange("Document No.", Rec."Document No.");
        totalcount := 0;

        if (saleslines.FindSet()) then begin
            repeat

                if (currentline = 0) or (currentline <> saleslines."Line No.") then begin
                    currentline := saleslines."Line No.";
                    currentcount := 1;
                    labelsallocated := 0;
                end;
                //Message(System.Format(saleslines."Line No.", 0, 0));
                //item.Reset();
                //item.SetRange("No.", saleslines."No.");
                // itemexists := item.Get(saleslines."No.");
                lblcartons.Get(saleslines."Document Type", saleslines."Document No.", saleslines."Line No.");

                itemcartons := 1;
                if (lblcartons.CartonSize > 1) then begin
                    itemcartons := Round(saleslines.Quantity / lblcartons.CartonSize, 1, '>');
                end;

                for itemloop := 1 to itemcartons do begin
                    totalcount := totalcount + 1;
                    label.Init();
                    label."Document Type" := saleslines."Document Type";
                    label."Document No." := saleslines."Document No.";
                    label."Line No." := saleslines."Line No.";
                    label.ItemNumber := saleslines."No.";
                    label.ItemCartonNo := itemloop;
                    label.ItemCartonCount := itemcartons;
                    label.OrderCartonNo := totalcount;
                    if (labelsallocated + lblcartons.CartonSize > saleslines.Quantity) then begin
                        label.Quantity := saleslines.Quantity - labelsallocated;
                    end else begin
                        label.Quantity := lblcartons.CartonSize;
                    end;
                    label.ItemDescription := saleslines.Description;
                    label.DocumentDate := saleslines."Shipment Date";
                    label.BestBeforeDate := label.DocumentDate + 6;
                    label.UofM := saleslines."Unit of Measure Code";
                    label.OrderQuantity := saleslines.Quantity;
                    label.Insert();
                    currentcount := currentcount + 1;

                    labelsallocated := labelsallocated + label.Quantity;
                end;
            // end for itemloop
            // end;
            until (saleslines.Next() = 0);


            ok := lblheader.Get(Rec."Document Type", Rec."Document No.");
            if ok then begin

                lblheader.OrderCartonCount := totalcount;
                lblheader.Modify()
            end;

            lblpage.Update(true);

        end;
    end;
}

