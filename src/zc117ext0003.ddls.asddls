@AbapCatalog.sqlViewAppendName: 'ZC117EXT0003_V'
@EndUserText.label: '[C1] Fake Standard Table Extend'
extend view ZC117CDS0003 with ZC117EXT0003 
{
    ztc1170001.zzsaknr,
    ztc1170001.zzkostl,
    ztc1170001.zzshkzg,
    ztc1170001.zzlgort
}
