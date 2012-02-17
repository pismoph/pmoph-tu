
var mypanel = new Ext.Panel({
    title: 'Hello',
    items: [
        new Ext.ux.form.PisComboBox({
           valueField: 'provcode'
           ,displayField: 'provname'
           ,urlStore: pre_url + '/code/cprovince'
           ,fieldStore: ['provcode', 'provname']
        })        
        
    ]
})