permissionset 50100 "BDELblPermissions.al"
{
    Assignable = true;
    Permissions = tabledata BDELabelCartons = RIMD,
        tabledata BDELabelHeader = RIMD,
        tabledata BDELabelLines = RIMD,
        table BDELabelCartons = X,
        table BDELabelHeader = X,
        table BDELabelLines = X,
        report BDELabelsReport = X,
        page "BDE Labels" = X,
        page BDELabelCartons = X,
        page BDELabelHeaders = X,
        page BDELabelsSubform = X,
        tabledata "BDE Assembly Lot" = RIMD,
        tabledata BDEAssemblyHeader = RIMD,
        tabledata BDEAssemblyLines = RIMD,
        table "BDE Assembly Lot" = X,
        table BDEAssemblyHeader = X,
        table BDEAssemblyLines = X,
        page BDEAssemblyList = X,
        page BDEAssemblyPage = X,
        page BDEAssemblySubForm = X;
}