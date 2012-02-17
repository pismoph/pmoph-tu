
var text1 = new Ext.form.TextField({
	id: 'text1',
	hideLabel: true,
	width: 655
});

var text2 = new Ext.form.TextField({
	id: 'text2',
	fieldLabel: 'เลขที่ตำแหน่ง',
	width: 120
});

var text3 = new Ext.form.TextField({
	id: 'text3',
	fieldLabel: 'เลขที่ตำแหน่ง',
	width: 120
});

var text4 = new Ext.form.TextField({
	id: 'text4',
	fieldLabel: 'หน่วยงาน',
	width: 100
});

var text5 = new Ext.form.NumberField({
	id: 'text5',
	fieldLabel: 'เงินเดือน (บาท)',
	width: 220
});

var text6 = new Ext.form.TextField({
	id: 'text6',
	fieldLabel: 'หมายเหตุ',
	width: 615
});

var text7 = new Ext.form.TextField({
	id: 'text7',
	fieldLabel: '',
	width: 493,
	readOnly: true,
	hideLabel: true,
	style: {
		background: '#CCCCCC'
	},
	value: ''
});

var text8 = new Ext.form.TextField({
	id: 'text8',
	fieldLabel: 'ชื่อ - สกุล',
	width: 300,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	},
	value: ''
});

var date1 = new Ext.form.DateField({
	id: 'date1',
	fieldLabel: 'วันที่มีผลบังคับใช้',
	format: 'd/m/Y',
	width: 100
});

var button1 = new Ext.Button({
	id: 'button1',
	iconCls: 'zoom',
	text: ''
});

var button3 = new Ext.Button({
	id: 'button3',
	text: 'เลือกคำสั่งแก้ไข'
});

var button2 = new Ext.Button({
	id: 'button2',
	iconCls: 'zoom',
	text: ''
});

var combo1 = new Ext.form.ComboBox({
	hiddenName: 'combo1',
	editable: true,
	fieldLabel: 'การเคลื่อนไหว',
	mode: 'local',
	width: 340,
	triggerAction: 'all',
	valueField: 'updcode',
	displayField: 'updname',
	store: new Ext.data.Store({
		url: '/code/cupdate',
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'Records',
			fields: ['updcode', 'updname']
		}),
		listeners: {
			load : function( Store, records, options ) {
				
			}
		}
	})
});

var combo2 = new Ext.form.ComboBox({
	hiddenName: 'combo2',
	editable: true,
	fieldLabel: 'ตำแหน่งสายงาน',
	mode: 'local',
	width: 220,
	triggerAction: 'all',
	valueField: 'poscode',
	displayField: 'posname',
	store: new Ext.data.Store({
		url: '/code/cposition',
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'Records',
			fields: ['poscode', 'posname']
		}),
		listeners: {
			load : function( Store, records, options ) {
				
			}
		}
	})
});

var combo3 = new Ext.form.ComboBox({
	hiddenName: 'combo3',
	editable: true,
	fieldLabel: 'ตำแหน่งบริหาร',
	mode: 'local',
	width: 220,
	triggerAction: 'all',
	valueField: 'excode',
	displayField: 'exname',
	store: new Ext.data.Store({
		url: '/code/cexecutive',
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'Records',
			fields: ['excode', 'exname']
		}),
		listeners: {
			load : function( Store, records, options ) {
				
			}
		}
	})
});

var combo4 = new Ext.form.ComboBox({
	hiddenName: 'combo4',
	editable: true,
	fieldLabel: 'กระทรวง',
	mode: 'local',
	width: 220,
	triggerAction: 'all',
	valueField: 'mcode',
	displayField: 'minname',
	store: new Ext.data.Store({
		url: '/code/cministry',
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'Records',
			fields: ['mcode', 'minname']
		}),
		listeners: {
			load : function( Store, records, options ) {
				
			}
		}
	})
});

var combo5 = new Ext.form.ComboBox({
	hiddenName: 'combo5',
	editable: true,
	fieldLabel: 'กรม',
	mode: 'local',
	width: 220,
	triggerAction: 'all',
	valueField: 'deptcode',
	displayField: 'deptname',
	store: new Ext.data.Store({
		url: '/code/cdept',
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'Records',
			fields: ['deptcode', 'deptname']
		}),
		listeners: {
			load : function( Store, records, options ) {
				combo5.setValue(combo5.getValue());
			}
		}
	})
});

var combo6 = new Ext.form.ComboBox({
	hiddenName: 'combo6',
	editable: true,
	fieldLabel: 'กลุ่มภารกิจ',
	mode: 'local',
	width: 220,
	triggerAction: 'all',
	valueField: 'subsdcode',
	displayField: 'subsdname',
	store: new Ext.data.Store({
		url: '/code/csubsdcode',
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'Records',
			fields: ['subsdcode', 'subsdname']
		}),
		listeners: {
			load : function( Store, records, options ) {
				
			}
		}
	})
});

var combo7 = new Ext.form.ComboBox({
	hiddenName: 'combo7',
	editable: true,
	fieldLabel: 'งาน',
	mode: 'local',
	width: 220,
	triggerAction: 'all',
	valueField: 'jobcode',
	displayField: 'jobname',
	store: new Ext.data.Store({
		url: '/code/cjob',
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'Records',
			fields: ['jobcode', 'jobname']
		}),
		listeners: {
			load : function( Store, records, options ) {
				combo7.setValue(combo7.getValue());
			}
		}
	})
});

var combo8 = new Ext.form.ComboBox({
	hiddenName: 'combo8',
	editable: true,
	fieldLabel: 'ระดับ',
	mode: 'local',
	width: 220,
	triggerAction: 'all',
	valueField: 'ccode',
	displayField: 'cname',
	store: new Ext.data.Store({
		url: '/code/cgrouplevel',
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'Records',
			fields: ['ccode', 'cname']
		}),
		listeners: {
			load : function( Store, records, options ) {
				
			}
		}
	})
});

var combo9 = new Ext.form.ComboBox({
	hiddenName: 'combo9',
	editable: true,
	fieldLabel: 'ความเชี่ยวชาญ',
	mode: 'local',
	width: 220,
	triggerAction: 'all',
	valueField: 'epcode',
	displayField: 'expert',
	store: new Ext.data.Store({
		url: '/code/cexpert',
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'Records',
			fields: ['epcode', 'expert']
		}),
		listeners: {
			load : function( Store, records, options ) {
				
			}
		}
	})
});

var combo10 = new Ext.form.ComboBox({
	hiddenName: 'combo10',
	editable: true,
	fieldLabel: 'กอง',
	mode: 'local',
	width: 220,
	triggerAction: 'all',
	valueField: 'dcode',
	displayField: 'division',
	store: new Ext.data.Store({
		url: '/code/cdivision',
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'Records',
			fields: ['dcode', 'division']
		}),
		listeners: {
			load : function( Store, records, options ) {
				combo10.setValue(combo10.getValue());
			}
		}
	})
});

var combo11 = new Ext.form.ComboBox({
	hiddenName: 'combo11',
	editable: true,
	fieldLabel: 'ฝ่าย / กลุ่มงาน',
	mode: 'local',
	width: 220,
	triggerAction: 'all',
	valueField: 'seccode',
	displayField: 'secname',
	store: new Ext.data.Store({
		url: '/code/csection',
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'Records',
			fields: ['seccode', 'secname']
		}),
		listeners: {
			load : function( Store, records, options ) {
				combo11.setValue(combo11.getValue());
			}
		}
	})
});

var combo12 = new Ext.form.ComboBox({
	hiddenName: 'combo12',
	editable: true,
	fieldLabel: 'โครงสร้างภายใน',
	mode: 'local',
	width: 220,
	triggerAction: 'all',
	valueField: 'off_id',
	displayField: 'off_name',
	store: new Ext.data.Store({
		url: 'person_pcucode.php',
		reader: new Ext.data.JsonReader({
			root: 'Records',
			fields: ['off_id', 'off_name']
		}),
		listeners: {
			load : function( Store, records, options ) {
				
			}
		}
	})
});

var combo13 = new Ext.form.ComboBox({
	hiddenName: 'combo13',
	editable: true,
	fieldLabel: 'ว. / วช. /ชช.',
	mode: 'local',
	width: 220,
	triggerAction: 'all',
	valueField: 'ptcode',
	displayField: 'ptname',
	store: new Ext.data.Store({
		url: '/code/cpostype',
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'Records',
			fields: ['ptcode', 'ptname']
		}),
		listeners: {
			load : function( Store, records, options ) {
				
			}
		}
	})
});

var checkbox1 = new Ext.form.Checkbox({
	id: 'checkbox1',
	boxLabel: 'ปรับปรุงข้อมูลตำแหน่ง (จ.18)...ถือจ่ายปัจจุบัน'
});

var checkbox2 = new Ext.form.Checkbox({
	id: 'checkbox2',
	boxLabel: 'ปรับปรุงข้อมูลปฏิบัติราชการปัจจุบัน'
});

var fieldset1 = new Ext.form.FieldSet({
	title: '',
	autoWidth: true,
	autoHeight: true,
	items : [
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [combo1]
				},
				{
					layout: 'form',
					items: [date1],
					style: 'padding-left:50px'
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [combo2]
				},
				{
					layout: 'form',
					items: [combo8],
					style: 'padding-left:50px'
				}
			]
		},{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text5]
				},
				{
					layout: 'form',
					items: [combo13],
					style: 'padding-left:50px'
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [combo3]
				},
				{
					layout: 'form',
					items: [combo9],
					style: 'padding-left:50px'
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [combo4]
				},
				{
					layout: 'form',
					items: [combo5],
					style: 'padding-left:50px'
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [combo10]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text4]
				},
				{
					layout: 'form',
					items: [text7]
				},
				{
					layout: 'form',
					items: [button2]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [combo6]
				},
				{
					layout: 'form',
					items: [combo11],
					style: 'padding-left:50px'
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [combo7]
				},
				{
					layout: 'form',
					items: [combo12],
					style: 'padding-left:50px'
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text6]
				}
			]
		}
	]
});

var frmAddEdit = new Ext.form.FormPanel({
	id: 'frmAddEdit',
	title: 'บันทึกคำสั่งแก้ไขคำสั่ง',
	labelAlign: 'left',
	labelWidth: 120,
	autoScroll: true,
	frame: true,
	monitorValid: true,
	region: 'center',
	items: [
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text2]
				},
				{
					layout: 'form',
					items: [button1]
				},
				{
					layout: 'form',
					items: [text8],
					style: 'padding-left:50px'
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [button3]
				},
				{
					layout: 'form',
					items: [text1]
				}
			]
		},
		fieldset1,
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [checkbox1]
				},
				{
					layout: 'form',
					items: [checkbox2]
				}
			]
		}
	],
	buttons: [
		{
			text: 'บันทึก',
			iconCls: 'disk',
			formBind: true,
			listeners: {
				click: function(){
					
				}
			}
		},
		{
			text: 'ยกเลิก',
			iconCls: 'arrow-undo',
			listeners: {
				click: function(){
					
				}
			}
		}
	]
});

var viewport = new Ext.Viewport({
	layout: 'border',
	renderTo: Ext.getBody(),
	//autoScroll: true,
	items: [
		frmAddEdit
	]
});

