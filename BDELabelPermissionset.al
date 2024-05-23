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
        page BDELabelsSubform = X;
}