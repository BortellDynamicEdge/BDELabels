report 50100 BDELabelsReport

//report 70389540 BDELabelsReport
{
    Caption = 'BDELabelsReport';
    RDLCLayout = './layouts/BDELabels.rdl';
    DefaultLayout = RDLC;


    dataset
    {
        dataitem(BDELabelLines; BDELabelLines)
        {

            DataItemTableView = sorting("Document Type", "Document No.", "Line No.", ItemCartonNo);
            //RequestFilterFields = "Document No.";

            column(ItemNumber; ItemNumber)
            {
            }
            column(ItemDescription; ItemDescription)
            {
            }
            column(ItemCartonNo; ItemCartonNo)
            {
            }
            column(ItemCartonCount; ItemCartonCount)
            {
            }
            column(DocumentDate; DocumentDate)
            {
            }
            column(BestBeforeDate; BestBeforeDate)
            {
            }
            column(OrderCartonNo; OrderCartonNo)
            {
            }
            column(Quantity; Quantity)
            {
            }
            column(OrderQuantity; OrderQuantity)
            {

            }
            column(UofM; UofM)
            {

            }

            dataitem(BDELabelsHeader; BDELabelHeader)
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("Document No.");
                DataItemLinkReference = BDELabelLines;

                column(OrderCartonCount; OrderCartonCount)
                {

                }
                column(CustomerName; CustomerName)
                {

                }

                column(Reference; Reference)
                {

                }
                column(Run; Run)
                {

                }
            }
        }
    }

    requestpage
    {

        SaveValues = true;

        layout
        {
            area(content)
            {

                // field(DocumentNumber; DocumementNumberFilter)
                // {
                //     Visible = true;
                //     Caption = 'Document Number';
                //     ApplicationArea = All;
                // }

                group(Options)
                {
                    Caption = 'BDEL Label Options';

                    // field(DocumementNumberFilter; BDELabelLines."Document No.")
                    // {
                    //     //ApplicationArea = Basic, Suite;
                    //     Caption = 'Document Number';
                    //     //TableRelation = BDELabelLines."Document No.";
                    //     //LookupPageId := 
                    // }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
        trigger OnOpenPage()
        begin
            BDELabelsHeader.Init();
            BDELabelsHeader.SetCurrentKey("Document Type", "Document No.");
            BDELabelsHeader."Document Type" := "Sales Document Type"::Order;
            BDELabelsHeader."Document No." := DocumementNumberFilter;
            BDELabelsHeader.SetRecFilter();
        end;
    }


    var

        reqpage: Report BDELabelsReport;

        DocumementNumberFilter: code[20];

    procedure SetParameters(docnumber: code[20])
    begin
        DocumementNumberFilter := docnumber;
    end;

    trigger OnPostReport()
    begin
        Clear(reqpage);
    end;


}


