reportextension 50100 InvoiceReportExt extends "Standard Sales - Invoice"

//reportextension 70389540 InvoiceReportExt extends "Standard Sales - Invoice"
{

    dataset
    {
        // addlast(Header)
        // {

        //     dataitem(customer; Customer)
        //     {
        //         DataItemLink = "No." = field("Bill-to Customer No.");
        //         column(CustomerBalance; Customer.GetTotalAmountLCY())
        //         {

        //         }
        //     }
        // }


        add(Header)
        {
            column(NumCartons; NumCartons)
            {

            }
            column(customerbalance; CustomerBalance)
            {

            }
        }

        modify(Header)
        {
            trigger OnAfterAfterGetRecord()
            var
                labelheader: Record BDELabelHeader;
                customer: Record Customer;
                ok: Boolean;

            begin
                ok := labelheader.Get("Sales Document Type"::Order, "Order No.");
                if (ok = false) then begin
                    NumCartons := 0;
                end;

                NumCartons := labelheader.OrderCartonCount;

                customer.Get("Bill-to Customer No.");
                CustomerBalance := customer.GetTotalAmountLCY();

            end;
        }
    }
    var
        NumCartons: Integer;
        CustomerBalance: Decimal;

}
