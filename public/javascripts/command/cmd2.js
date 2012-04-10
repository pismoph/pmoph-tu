var pre_url = "";

var text1 = new Ext.form.TextField({
	id: 'text1',
	fieldLabel: 'เลขที่คำสั่ง',
	width: 400,
	allowBlank: false
});

var date1 = new Ext.form.DateField({
	fieldLabel: 'วันที่คำสั่งมีผลบังคับ',
	format: 'd/m/Y',
	allowBlank: false
});

var combo1 = new Ext.ux.form.PisComboBox({
	fieldLabel: 'การเคลื่อนไหว'
	,hiddenName: 'combo1'
	,allowBlank: false
	,width: 685
	,valueField: 'updcode'
	,displayField: 'updname'
	,urlStore: pre_url + '/codetu/cupdate'
	,fieldStore: ['updcode', 'updname']
});

var text6 = new Ext.form.TextField({
	fieldLabel: 'หมายเหตุ',
	width: 685
});

var radio1 = new Ext.form.RadioGroup({
	fieldLabel: '',
	columns: 5,
	width: 650,
	items: [{
		name: 'radio1',
		inputValue: '1',
		boxLabel: 'สับตรง'
	},{
		name: 'radio1',
		inputValue: '2',
		boxLabel: 'สับเปลี่ยนเงิน'
	},{
		name: 'radio1',
		inputValue: '3',
		boxLabel: 'ขาดอัตรามาเบิก'
	},{
		name: 'radio1',
		inputValue: '4',
		boxLabel: 'อาศัยเบิก'
	},{
		name: 'radio1',
		inputValue: '5',
		boxLabel: 'ไม่มี',
		checked: true
	}]
});

function text2_get_position(me){
	Ext.Ajax.request({
		method: 'post',
		url: pre_url+'/cmd2/get_position',
		params: {posid: me.getValue()},
		success: function(result, request ) {
			var x = me.getValue();
			var dat = Ext.util.JSON.decode(result.responseText).Records[0];
			if(Ext.util.JSON.decode(result.responseText).Records.length > 0){
				text2.setValue(x);
				//text3.setValue(x);
				ttt = dat.fullname;
				if(ttt == "") ttt = "ว่าง";
				text8.setValue(ttt);
				
				//combo2.setValue(dat.poscode);
				combo2.getStore().load({
					params: {
						poscode: dat.poscode
						,start: 0
						,limit: 10
					},
					callback :function(){
						combo2.setValue(dat.poscode);
					}
				});
				
				//combo8.setValue(dat.ccode);
				combo8.getStore().load({
					params: {
						ccode: dat.ccode
						,start: 0
						,limit: 10
					},
					callback :function(){
						combo8.setValue(dat.ccode);
					}
				});
				
				//เงินเดือน
				text5.setValue(dat.salary);
				
				//combo3.setValue(dat.excode);
				combo3.getStore().load({
					params: {
						excode: dat.excode
						,start: 0
						,limit: 10
					},
					callback :function(){
						combo3.setValue(dat.excode);
					}
				});
				
				//combo9.setValue(dat.epcode);
				combo9.getStore().load({
					params: {
						epcode: dat.epcode
						,start: 0
						,limit: 10
					},
					callback :function(){
						combo9.setValue(dat.epcode);
					}
				});
				
				//combo13.setValue(dat.ptcode);
				combo13.getStore().load({
					params: {
						ptcode: dat.ptcode
						,start: 0
						,limit: 10
					},
					callback :function(){
						combo13.setValue(dat.ptcode);
					}
				});
				
				//combo4.setValue(dat.mincode);
				/*combo4.getStore().load({
					params: {
						mcode: dat.mincode
						,start: 0
						,limit: 10
					},
					callback :function(){
						combo4.setValue(dat.mincode);
					}
				});*/
				
				//combo5.setValue(dat.deptcode);
				/*combo5.getStore().load({
					params: {
						deptcode: dat.deptcode
						,start: 0
						,limit: 10
					},
					callback :function(){
						combo5.setValue(dat.deptcode);
					}
				});*/
				
				//combo10.setValue(dat.dcode);
				combo10.getStore().load({
					params: {
						dcode: dat.dcode
						,start: 0
						,limit: 10
					},
					callback :function(){
						combo10.setValue(dat.dcode);
					}
				});
				
				text4.setValue(dat.sdcode);
				text7.setValue(dat.fullsubdeptname);
				
				//combo11.setValue(dat.seccode);
				combo11.getStore().load({
					params: {
						seccode: dat.seccode
						,start: 0
						,limit: 10
					},
					callback :function(){
						combo11.setValue(dat.seccode);
					}
				});
				
				//combo7.setValue(dat.jobcode);
				combo7.getStore().load({
					params: {
						jobcode: dat.jobcode
						,start: 0
						,limit: 10
					},
					callback :function(){
						combo7.setValue(dat.jobcode);
					}
				});
				
				combo6.setValue("");
				//combo12.setValue("");
			} else {
				Ext.Msg.show({
					title:'ไม่พบข้อมูล',
					msg: 'เลขที่ตำแหน่งนี้จะต้องเป็นตำแหน่งว่างเท่านั้น',
					buttons: Ext.Msg.OK,
					fn: function(){
						text2.setValue('');
					},
					icon: Ext.MessageBox.ERROR
				});
				//ก่อนจะรีเซตฟอร์ม ต้องสำรองข้อมูลใน การเคลื่อนไหว, คำสั่ง และ วันที่มีผลบังคับใช้ เอาไว้ก่อน
				/*a = combo1.getValue();
				b = text1.getValue();
				c = date1.getValue();
				frmAddEdit.getForm().reset();
				combo1.setValue(a);
				text1.setValue(b);
				if(c != ""){
					c = c.format("d")+"/"+c.format("m")+"/"+ (Number(c.format("Y"))+543).toString();
					date1.setValue(c);
				}*/
			}
		}
	});
}

var text2 = new Ext.form.NumberField({
	id: 'text2',
	fieldLabel: 'เลขที่ตำแหน่ง',
	width: 120,
	allowBlank: false,
	enableKeyEvents: true,
	listeners: {
		keypress: function( me, e ){
			if(e.keyCode == e.ENTER){
				text2_get_position(me);
			}
		},
		change: function( me, newValue, oldValue ){
			if(me.getValue() != ""){
				text2_get_position(me);
			}
		}
	}
});

var hid_id = new Ext.form.Hidden({
	id: 'hid_id'
});

function text3_get_olddata(){
	Ext.Ajax.request({
		method: 'post',
		url: pre_url+'/cmd2/get_olddata',
		params: {posid: text3.getValue()},
		success: function(result, request ) {
			//var x = text3.getValue();
			//frmAddEdit.getForm().reset();
			if(Ext.util.JSON.decode(result.responseText).Records.length == 0){
				Ext.Msg.show({
					title:'ไม่พบข้อมูล',
					msg: 'เลขที่ตำแหน่งนี้ จะต้องเป็นคนที่อยู่ในรายชื่อชั่วคราวเท่านั้น',
					buttons: Ext.Msg.OK,
					fn: function(){
						text3.setValue('');
					},
					icon: Ext.MessageBox.ERROR
				});
				return;
			}
			var dat = Ext.util.JSON.decode(result.responseText).Records[0];
			var dat2 = Ext.util.JSON.decode(result.responseText).Records2[0];
			
			if(Ext.util.JSON.decode(result.responseText).Records.length > 0){
				//text3.setValue(x);
				hid_id.setValue(dat.id);
				text21.setValue(dat.fullname);
				text22.setValue(dat.posname);
				text23.setValue(dat.cname);
				text24.setValue(dat.salary);
				text25.setValue(dat.exname);
				text26.setValue(dat.expert);
				text27.setValue(dat.ptname);
				text28.setValue(dat.division);
				text29.setValue(dat.fullsubdeptname);
				text30.setValue(dat.subsdname);
				text31.setValue(dat.secname);
				text32.setValue(dat.jobname);
				
				//text2.setValue(text3.getValue());
				//text2_get_position(text2);
				
				combo14.setValue(dat2.j18code);
				text42.setValue(dat2.deptname);
				text43.setValue(dat2.division);
				text44.setValue(dat2.fullsubdeptname);
				text45.setValue(dat2.subsdname);
				text46.setValue(dat2.secname);
				text47.setValue(dat2.jobname);
				//text48.setValue(dat2.fullname);
			} else {
				Ext.Msg.alert("Error","ไม่พบข้อมูลตำแหน่ง");
			}
		}
	});	
}

var text3 = new Ext.form.NumberField({
	fieldLabel: 'เลขที่ตำแหน่ง',
	width: 120,
	allowBlank: false,
	enableKeyEvents: true,
	listeners: {
		keypress: function( me, e ){
			if(e.keyCode == e.ENTER){
				text3_get_olddata();
			}
		}
	}
});

function text4_query(id){
	if(id != ""){
		Ext.Ajax.request({
			method: 'post',
			url: pre_url+'/cmd2/get_place',
			params: {id: id},
			success: function(result, request ) {
				var dat = Ext.util.JSON.decode(result.responseText).Records;
				if(dat.length == 0){
					text7.setValue('');
					Ext.Msg.show({
						title:'ไม่พบข้อมูล',
						msg: 'ไม่พบข้อมูลหน่วยงานที่ค้นหา',
						buttons: Ext.Msg.OK,
						fn: function(){},
						animEl: 'text4',
						icon: Ext.MessageBox.ERROR
					});
				} else {
					text7.setValue(dat[0].fullsubdeptname);
				}
			}
		});
	}
}

var text4 = new Ext.form.NumberField({
	id: 'text4',
	fieldLabel: 'หน่วยงาน',
	width: 100,
	allowBlank: false,
	enableKeyEvents: true,
	listeners: {
		keypress: function( me, e ){
			if(e.keyCode == e.ENTER){
				text4_query(me.getValue());
			}
		},
		change: function( me, newValue, oldValue ){
			text4_query(me.getValue());
		}
	}
});

var text5 = new Ext.form.NumberField({
	id: 'text5',
	fieldLabel: 'เงินเดือน',
	width: 120,
	allowBlank: false
});



var text7 = new Ext.form.TextField({
	id: 'text7',
	fieldLabel: '',
	width: 250,
	readOnly: true,
	hideLabel: true,
	style: {
		background: '#CCCCCC'
	}
});

var text8 = new Ext.form.TextField({
	id: 'text8',
	fieldLabel: 'ชื่อผู้ครองตำแหน่งเดิม',
	width: 350,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});

var text21 = new Ext.form.TextField({
	id: 'text21',
	fieldLabel: 'ชื่อผู้ครองตำแหน่ง',
	width: 300,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});

var text22 = new Ext.form.TextField({
	id: 'text22',
	fieldLabel: 'ตำแหน่งสายงาน',
	width: 300,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});

var text23 = new Ext.form.TextField({
	id: 'text23',
	fieldLabel: 'ระดับ',
	width: 300,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});

var text24 = new Ext.form.TextField({
	id: 'text24',
	fieldLabel: 'เงินเดือน',
	width: 120,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});

var text25 = new Ext.form.TextField({
	id: 'text25',
	fieldLabel: 'ตำแหน่งบริหาร',
	width: 300,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});

var text26 = new Ext.form.TextField({
	id: 'text26',
	fieldLabel: 'ความเชี่ยวชาญ',
	width: 300,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});

var text27 = new Ext.form.TextField({
	id: 'text27',
	fieldLabel: 'ว. / วช. / ชช.',
	width: 300,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});

var text28 = new Ext.form.TextField({
	id: 'text28',
	fieldLabel: 'กอง',
	width: 300,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});

var text29 = new Ext.form.TextField({
	id: 'text29',
	fieldLabel: 'ชื่อหน่วยงาน',
	width: 300,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});

var text30 = new Ext.form.TextField({
	id: 'text30',
	fieldLabel: 'กลุ่ม',
	width: 300,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});

var text31 = new Ext.form.TextField({
	id: 'text31',
	fieldLabel: 'ฝ่าย / กลุ่มงาน',
	width: 300,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});

var text32 = new Ext.form.TextField({
	id: 'text32',
	fieldLabel: 'งาน',
	width: 300,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});

var text40 = new Ext.form.TextField({
	id: 'text40',
	fieldLabel: 'อาศัยเบิกอันดับ',
	width: 80
});

var text41 = new Ext.form.TextField({
	id: 'text41',
	fieldLabel: 'ขั้น',
	width: 150
});

var text42 = new Ext.form.TextField({
	id: 'text42',
	fieldLabel: 'กรม',
	width: 300,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});

var text43 = new Ext.form.TextField({
	id: 'text43',
	fieldLabel: 'กอง',
	width: 300,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});

var text44 = new Ext.form.TextField({
	id: 'text44',
	fieldLabel: 'ชื่อหน่วยงาน',
	width: 750,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});

var text45 = new Ext.form.TextField({
	id: 'text45',
	fieldLabel: 'กลุ่ม',
	width: 300,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});

var text46 = new Ext.form.TextField({
	id: 'text46',
	fieldLabel: 'ฝ่าย / กลุ่มงาน',
	width: 300,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});

var text47 = new Ext.form.TextField({
	id: 'text47',
	fieldLabel: 'งาน',
	width: 300,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});

var text48 = new Ext.form.TextField({
	id: 'text48',
	fieldLabel: 'โครงสร้างภายใน',
	width: 300,
	readOnly: true,
	style: {
		background: '#CCCCCC'
	}
});


var button1 = new Ext.Button({
	id: 'button1',
	iconCls: 'zoom',
	text: '',
	tooltip: 'ค้นหาหน่วยงาน',
	listeners: {
		click: function(){
			winPlace.show();
		}
	}
});

var button2 = new Ext.Button({
	id: 'button2',
	iconCls: 'zoom',
	text: 'ตำแหน่งว่าง',
	tooltip: 'ตำแหน่งว่าง',
	listeners: {
		click: function(){
			winPositionBlank.setPosition(button2.getPosition());
			winPositionBlank.show();
			cmbSearchPositionBlank.setValue(1); //เมื่อเปิดหน้าต่างครั้งแรกให้ แสดงตำแหน่งว่างมารอไว้ก่อน
			funcSearchPositionBlank();
		}
	}
});

var button3 = new Ext.Button({
	id: 'button3',
	iconCls: 'user-go',
	text: 'ย้ายคนออกจากตำแหน่งชั่วคราว',
	tooltip: 'ย้ายคนออกจากตำแหน่งชั่วคราว',
	listeners: {
		click: function(){
			winSearchPosition.setPosition(button3.getPosition());
			winSearchPosition.show();
			cmbSearchPosition.setValue(1); //เมื่อเปิดหน้าต่างครั้งแรกให้ แสดงรายชื่อตำแหน่งชื่อคนมาทั้งหมด
			funcSearchPosition();
		}
	}
});

var button4 = new Ext.Button({
	id: 'button4',
	iconCls: 'zoom',
	text: 'รายชื่อชั่วคราว',
	tooltip: 'รายชื่อชั่วคราว',
	listeners: {
		click: function(){
			winTmp.setPosition(button4.getPosition());
			winTmp.show();
			GridTmpStore.load();
		}
	}
});

var combo2 = new Ext.ux.form.PisComboBox({
	fieldLabel: 'ตำแหน่งสายงาน'
	,hiddenName: 'combo2'
	,width: 350
	,valueField: 'poscode'
	,displayField: 'posname'
	,urlStore: pre_url + '/codetu/cposition'
	,fieldStore: ['poscode', 'posname']
});

var combo3 = new Ext.ux.form.PisComboBox({
	fieldLabel: 'ตำแหน่งบริหาร'
	,hiddenName: 'combo3'
	,width: 350
	,valueField: 'excode'
	,displayField: 'exname'
	,urlStore: pre_url + '/codetu/cexecutive'
	,fieldStore: ['excode', 'exname']
});

var combo9 = new Ext.ux.form.PisComboBox({
	fieldLabel: 'ความเชี่ยวชาญ'
	,hiddenName: 'combo9'
	,width: 350
	,valueField: 'epcode'
	,displayField: 'expert'
	,urlStore: pre_url + '/codetu/cexpert'
	,fieldStore: ['epcode', 'expert']
});

var combo13 = new Ext.ux.form.PisComboBox({
	fieldLabel: 'ว. / วช. /ชช.'
	,hiddenName: 'combo13'
	,width: 350
	,valueField: 'ptcode'
	,displayField: 'ptname'
	,urlStore: pre_url + '/codetu/cpostype'
	,fieldStore: ['ptcode', 'ptname']
});

var combo7 = new Ext.ux.form.PisComboBox({
	fieldLabel: 'งาน'
	,hiddenName: 'combo7'
	,width: 350
	,valueField: 'jobcode'
	,displayField: 'jobname'
	,urlStore: pre_url + '/codetu/cjob'
	,fieldStore: ['jobcode', 'jobname']
});

var combo14 = new Ext.form.ComboBox({
	hiddenName: 'combo14',
	editable: true,
	fieldLabel: 'ปฏิบัติงานจริง',
	mode: 'local',
	width: 220,
	triggerAction: 'all',
	valueField: 'j18code',
	displayField: 'j18status',
	store: new Ext.data.Store({
		url: pre_url+'/codetu/cj18status',
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'Records',
			fields: ['j18code', 'j18status']
		}),
		listeners: {
			load : function( Store, records, options ) {
				
			}
		}
	})
});

var combo10 = new Ext.ux.form.PisComboBox({
	fieldLabel: 'กอง'
	,hiddenName: 'combo10'
	,width: 350
	,valueField: 'dcode'
	,displayField: 'division'
	,urlStore: pre_url + '/codetu/cdivision'
	,fieldStore: ['dcode', 'division']
});

var combo6 = new Ext.ux.form.PisComboBox({
	fieldLabel: 'กลุ่มภารกิจ'
	,hiddenName: 'combo6'
	,width: 350
	,valueField: 'subsdcode'
	,displayField: 'subsdname'
	,urlStore: pre_url + '/codetu/csubsdcode'
	,fieldStore: ['subsdcode', 'subsdname']
});

var combo8 = new Ext.ux.form.PisComboBox({
	fieldLabel: 'ระดับ'
	,hiddenName: 'combo8'
	,width: 350
	,valueField: 'ccode'
	,displayField: 'cname'
	,urlStore: pre_url + '/codetu/cgrouplevel'
	,fieldStore: ['ccode', 'cname']
});

var combo11 = new Ext.ux.form.PisComboBox({
	fieldLabel: 'ฝ่าย / กลุ่มงาน'
	,hiddenName: 'combo11'
	,width: 350
	,valueField: 'seccode'
	,displayField: 'secname'
	,urlStore: pre_url + '/codetu/csection'
	,fieldStore: ['seccode', 'secname']
});

var fieldset1 = new Ext.form.FieldSet({
	title: 'ตำแหน่งที่แต่งตั้ง (จะต้องเป็นตำแหน่งว่างเท่านั้น)',
	width: 530,
	items : [
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text2]
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
					items: [text8]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [combo2]
				}
			]
		},{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [combo8]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text5]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [combo3]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [combo9]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [combo13]
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
					items: [button1]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [combo6]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [combo11]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [combo7]
				}
			]
		}
	]
});

var fieldset2 = new Ext.form.FieldSet({
	title: 'ตำแหน่งเดิม (จะต้องเป็นคนที่อยู่ในรายชื่อชั่วคราวเท่านั้น)',
	width: 400,
	items : [
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text3]
				},
				{
					layout: 'form',
					items: [button4]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text21]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text22]
				}
			]
		},{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text23]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text24]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text25]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text26]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text27]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text28]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text29]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text30]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text31]
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text32]
				}
			]
		}
	]
});

var fieldset3 = new Ext.form.FieldSet({
	title: '',
	width: 940,
	labelWidth: 95,
	items : [
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [combo14]
				},{
					layout: 'form',
					items: [text40],
					style: 'padding-left:50px'
				},{
					layout: 'form',
					items: [text41],
					style: 'padding-left:50px'
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text42]
				},{
					layout: 'form',
					items: [text43],
					style: 'padding-left:50px'
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text44]
				}
			]
		},{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text45]
				},{
					layout: 'form',
					items: [text46],
					style: 'padding-left:50px'
				}
			]
		},
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text47]
				},{
					layout: 'form',
					items: [text48],
					style: 'padding-left:50px'
				}
			]
		}
	]
});

var frmAddEdit = new Ext.form.FormPanel({
	title: 'บันทึกคำสั่งย้าย / เลื่อนภายในหน่วยงาน',
	labelAlign: 'left',
	labelWidth: 130,
	frame: true,
	region: 'center',
	autoScroll: true,
	monitorValid: true,
	items: [
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [text1]
				},{
					layout: 'form',
					style: 'padding-left: 20px',
					items: [date1]
				}
			]
		},
		combo1,
		text6,
		//radio1,
		button3,
		{
			layout: 'column',
			items: [
				{
					layout: 'form',
					items: [fieldset2]
				},{
					layout: 'form',
					style: 'padding-left: 10px',
					items: [fieldset1]
				}
			]
		},
		fieldset3
	],
	buttons: [
		{
			text: 'บันทึก',
			iconCls: 'disk',
			formBind: true,
			listeners: {
				click: function(){
					save_data();
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

//------------------------------------------------------------------------------
function funcSearchPlace(){
	GridStorePlace.baseParams = {
		provcode: cmbSearchPlace.getValue(),
		query: txtSearchPlace.getValue()
	};
	GridStorePlace.load({
		params:{
			start: 0,
			limit: 100
		}
	});
}

var cmbSearchPlace = new Ext.form.ComboBox({
	hiddenName: 'cmbSearchPlace',
	editable: true,
	mode: 'local',
	width: 150,
	triggerAction: 'all',
	valueField: 'provcode',
	displayField: 'provname',
	store: new Ext.data.Store({
		url: pre_url+'/codetu/cprovince',
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			root: 'Records',
			fields: ['provcode', 'provname']
		})
	}),
	listeners: {
		select : function( me, record, index ) {
			if(me.getValue() != ""){
				funcSearchPlace();
			}
		}
	}
});

var txtSearchPlace = new Ext.form.TextField({
	id: 'txtSearchPlace',
	width: 200,
	enableKeyEvents: true,
	listeners: {
		keypress: function( me, e ){
			if(e.keyCode == e.ENTER){
				funcSearchPlace();
			}
		}
	}
});

var btnSearchPlace = new Ext.Button({
	id: 'btnSearchPlace',
	iconCls: 'zoom',
	text: '',
	listeners: {
		click: function(){
			funcSearchPlace();
		}
	}
});

var GridStorePlace = new Ext.data.JsonStore({
	url: pre_url+'/cmd2/list_place_dialog',
	root: 'Records',
	totalProperty: 'totalCount',
	idProperty: 'sdcode',
	fields: [
		"sdcode",
		"fullsubdeptname"
	]
});

function setResultPlace(){
	text4.setValue(GridPlace.selModel.selections.items[0].data.sdcode);
	text7.setValue(GridPlace.selModel.selections.items[0].data.fullsubdeptname);
	//text4_selected();
	winPlace.hide();
}

var GridPlace = new Ext.grid.GridPanel({
	title: '',
	frame: false,
	stripeRows: true,
	store: GridStorePlace,
	viewConfig: {forceFit: true},
	loadMask: {
		msg: 'Please wait...'
	},
	columns: [
		new Ext.grid.RowNumberer(),
		{header: "รหัสหน่วยงาน",dataIndex: 'sdcode', width: 2, sortable: true},
		{header: "ชื่อหน่วยงาน",dataIndex: 'fullsubdeptname', width: 10, sortable: true}
	],
	listeners: {
		rowdblclick: function( me, rowIndex, e ){
			setResultPlace();
		}
	},
	tbar: [
		'จังหวัด : ',
		cmbSearchPlace,
		'คำค้นหาชื่อหน่วยงาน : ',
		txtSearchPlace,
		btnSearchPlace
	],
	bbar: new Ext.PagingToolbar({
		store: GridStorePlace,
		pageSize: 100,
		displayInfo: true,
		displayMsg: 'รายการที่ {0} - {1} จากทั้งหมด {2}',
		emptyMsg: "ไม่มีข้อมูล"
	})
});

var winPlace = new Ext.Window({
	title: 'ค้นหาหน่วยงาน',
	iconCls: 'book-open',
	applyTo: 'div_window_place',
	layout: 'fit',
	width: 550,
	height: 450,
	autoScroll: true,
	closeAction: 'hide',
	modal: true,
	showAnimDuration: 0.5,
	hideAnimDuration: 0.5,
	items: [
		GridPlace
	],
	buttons: [{
			text: 'ตกลง',
			iconCls: 'accept',
			formBind: true,
			listeners: {
				click: function(){
					if( GridPlace.selModel.selections.items.length != 0 ){
						setResultPlace();
					} else {
						Ext.Msg.alert("Error", "กรุณาคลิกเลือกชื่อหน่วยงานที่ต้องการ");
					}
				}
			}
		},{
			text: 'ยกเลิก',
			iconCls: 'arrow-undo',
			listeners: {
				click: function(){
					winPlace.hide();
				}
			}
		}
	]
});

function save_data(){
	Ext.Ajax.request({
		method: 'post',
		url: pre_url+'/cmd2/save',
		params: {
			posid_old: text3.getValue(), //ตำแหน่งเก่า
			hid_id: hid_id.getValue(), //รหัสของคนเก่า
			
			updcode: combo1.getValue(), //การเคลื่อนไหว
			refcmnd: text1.getValue(), //คำสั่ง
			forcedate: date1.getValue(), //วันที่มีผลบังคับใช้

			posid: text2.getValue(), //เลขที่ตำแหน่ง
			
			j18code: combo14.getValue(), //ปฏิบัติงานตรง จ.18
			poscode: combo2.getValue(), //ตำแหน่งสายงาน
			c: combo8.getValue(), //ระดับ
			salary: text5.getValue(), //เงินเดือน
			excode: combo3.getValue(), //ตำแหน่งบริหาร
			epcode: combo9.getValue(), //ความเชี่ยวชาญ
			ptcode: combo13.getValue(), //ว./วช./ชช.
			//mincode: combo4.getValue(), //กระทรวง
			//deptcode: combo5.getValue(), //กรม
			dcode: combo10.getValue(), //กอง
			sdcode: text4.getValue(), //รหัสหน่วยงาน
			seccode: combo11.getValue(), //ฝ่าย /กลุ่มงาน
			jobcode: combo7.getValue(), //งาน
			fullname: text7.getValue(),
			subdcode: combo6.getValue(), //กลุ่มภารกิจ

			//note: 'ไปปฏิบัติราชการ '+text7.getValue()+' '+text6.getValue(), //หมายเหตุ
			note: text6.getValue(), //หมายเหตุ
			
			upddate: '', //วันที่บันทึก เดี๋ยวให้ทาง postgres บันทึกเวลาเอง
			upduser: 'admin' //user ที่บันทึก
		},
		success: function(result, request ) {
			obj = Ext.util.JSON.decode(result.responseText);
			//debugger;
			if( obj.success == true){
				Ext.Msg.show({
					title:'Complete',
					msg: 'บันทึกข้อมูลเสร็จแล้ว',
					buttons: Ext.Msg.OK,
					fn: function(){
						//ก่อนจะรีเซตฟอร์ม ต้องสำรองข้อมูลใน การเคลื่อนไหว, คำสั่ง และ วันที่มีผลบังคับใช้ เอาไว้ก่อน
						a = combo1.getValue();
						b = text1.getValue();
						c = date1.getValue();
						frmAddEdit.getForm().reset();
						//การเคลื่อนไหว
						combo1.getStore().load({
							params: {
								updcode: a
								,start: 0
								,limit: 10
							},
							callback :function(){
								combo1.setValue(a);
							}
						});
						text1.setValue(b);
						if(c != ""){
							c = c.format("d")+"/"+c.format("m")+"/"+ (Number(c.format("Y"))+543).toString();
							date1.setValue(c);
						}
					},
					animEl: 'text1',
					icon: Ext.MessageBox.INFO
				});
			} else {
				Ext.Msg.show({
					title:'Error',
					msg: 'เกิดข้อผิดพลาดในการบันทึก',
					buttons: Ext.Msg.OK,
					fn: function(){},
					animEl: 'text1',
					icon: Ext.MessageBox.ERROR
				});
			}
		}
	});
}



function funcSearchPosition(){
	GridStorePosition.baseParams = {
		condition_id: cmbSearchPosition.getValue(),
		query: txtSearchPosition.getValue()
	};
	GridStorePosition.load({
		params:{
			start: 0,
			limit: 100
		}
	});
}

function move_to_tmp(posid, id){
	//Ext.Msg.alert('Msg', 'posid='+posid+', id='+id);
	//ทำการปลดคนออกจากตำแหน่ง โดยย้าย posid ไปไว้ที่ last_posid
	// และทำให้ตาราง pisj18 ไม่มี id ของคนอยู่
	Ext.Ajax.request({
		method: 'post',
		url: pre_url+'/cmd2/move_to_tmp',
		params: {posid: posid, id: id},
		success: function(result, request ) {
			obj = Ext.util.JSON.decode(result.responseText);
			if( obj.success == true){
				Ext.Msg.show({
					title:'Complete',
					msg: 'ทำการย้ายคนไปที่รายชื่อชั่วคราวแล้ว',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.INFO
				});
				winSearchPosition.hide();
			} else {
				Ext.Msg.show({
					title:'Error',
					msg: 'เกิดข้อผิดพลาด ไม่สามารถย้ายคนไปที่รายชื่อชั่วคราวได้',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
			}
		}
	});
}

var GridStorePosition = new Ext.data.JsonStore({
	url: pre_url+'/cmd2/list_position',
	root: 'Records',
	totalProperty: 'totalCount',
	idProperty: 'posid',
	fields: [
		"posid",
		"posname",
		"fullname",
		"id"
	]
});

var GridPosition = new Ext.grid.GridPanel({
	id: 'GridPosition',
	title: '',
	frame: false,
	stripeRows: true,
	store: GridStorePosition,
	viewConfig: {forceFit: true},
	loadMask: {
		msg: 'Please wait...'
	},
	columns: [
		new Ext.grid.RowNumberer(),
		{header: "เลขที่ตำแหน่ง",dataIndex: 'posid', width: 4, sortable: true},
		{header: "ตำแหน่ง",dataIndex: 'posname', width: 10, sortable: true},
		{header: "ชื่อ - นามสกุล",dataIndex: 'fullname', width: 10, sortable: true}
	],
	listeners: {
		rowdblclick: function( me, rowIndex, e ){
			move_to_tmp(me.selModel.selections.items[0].data.posid, me.selModel.selections.items[0].data.id);
		}
	},
	tbar: [
		'ค้นหาโดย : ',
		cmbSearchPosition = new Ext.form.ComboBox({
			hiddenName: 'cmbSearchPosition',
			mode: 'local',
			width: 200,
			triggerAction: 'all',
			valueField: 'condition_id',
			displayField: 'condition_text',
			store: new Ext.data.ArrayStore({
				fields: ['condition_id', 'condition_text'],
				data: [['1', 'ชื่อ-นามสกุลผู้ครองตำแหน่ง'], ['2', 'ตำแหน่งสายงาน']]
			}),
			listeners: {
				select : function( me, record, index ) {
					funcSearchPosition();
				}
			}
		}),
		'คำค้นหา : ',
		txtSearchPosition = new Ext.form.TextField({
			id: 'txtSearchPosition',
			width: 200,
			enableKeyEvents: true,
			listeners: {
				keypress: function( me, e ){
					if(e.keyCode == e.ENTER){
						funcSearchPosition();
					}
				}
			}
		}),
		btnSearchPosition = new Ext.Button({
			id: 'btnSearchPosition',
			iconCls: 'zoom',
			text: '',
			listeners: {
				click: function(){
					funcSearchPosition();
				}
			}
		})
	],
	bbar: new Ext.PagingToolbar({
		store: GridStorePosition,
		pageSize: 100,
		displayInfo: true,
		displayMsg: 'รายการที่ {0} - {1} จากทั้งหมด {2}',
		emptyMsg: "ไม่มีข้อมูล"
	})
});

var winSearchPosition = new Ext.Window({
	id: 'winSearchPosition',
	title: 'รายชื่อข้าราชการ (เลือกเพื่อย้ายไปยังรายชื่อชั่วคราว)',
	iconCls: 'book-open',
	applyTo: 'div_window_searchposition',
	layout: 'fit',
	width: 600,
	height: 420,
	autoScroll: true,
	closeAction: 'hide',
	modal: true,
	items: [
		GridPosition
	],
	buttons: [
		{
			text: 'ตกลง',
			iconCls: 'accept',
			formBind: true,
			listeners: {
				click: function(){
					if( GridPosition.selModel.selections.items.length != 0 ){
						move_to_tmp(GridPosition.selModel.selections.items[0].data.posid, GridPosition.selModel.selections.items[0].data.id);
					} else {
						Ext.Msg.alert("Error", "กรุณาคลิกเลือกเลขที่ตำแหน่งที่ต้องการ");
					}
				}
			}
		},
		{
			text: 'ยกเลิก',
			iconCls: 'arrow-undo',
			listeners: {
				click: function(){
					winSearchPosition.hide();
				}
			}
		}
	]
});

var GridTmpStore = new Ext.data.JsonStore({
	url: pre_url+'/cmd2/list_tmp',
	root: 'Records',
	//totalProperty: 'totalCount',
	idProperty: 'posid',
	fields: [
		"posid",
		"posname",
		"fullname"
	]
});

var GridTmp = new Ext.grid.GridPanel({
	id: 'GridTmp',
	title: '',
	frame: false,
	stripeRows: true,
	store: GridTmpStore,
	viewConfig: {forceFit: true},
	loadMask: {
		msg: 'Please wait...'
	},
	columns: [
		new Ext.grid.RowNumberer(),
		{header: "เลขที่ตำแหน่ง",dataIndex: 'posid', width: 4, sortable: true},
		{header: "ตำแหน่ง",dataIndex: 'posname', width: 10, sortable: true},
		{header: "ชื่อ - นามสกุล",dataIndex: 'fullname', width: 10, sortable: true}
	],
	listeners: {
		rowdblclick: function( me, rowIndex, e ){
			text3.setValue(me.selModel.selections.items[0].data.posid);
			winTmp.hide();
			text3_get_olddata();
		}
	}
});

var winTmp = new Ext.Window({
	id: 'winTmp',
	title: 'รายชื่อชั่วคราว',
	iconCls: 'user-go',
	applyTo: 'div_window_tmp',
	layout: 'fit',
	width: 600,
	height: 420,
	autoScroll: true,
	closeAction: 'hide',
	modal: true,
	items: [
		GridTmp
	],
	buttons: [
		{
			text: 'ตกลง',
			iconCls: 'accept',
			formBind: true,
			listeners: {
				click: function(){
					if( GridTmp.selModel.selections.items.length != 0 ){
						text3.setValue(GridTmp.selModel.selections.items[0].data.posid);
						winTmp.hide();
						text3_get_olddata();
					} else {
						Ext.Msg.alert("Error", "กรุณาคลิกเลือกเลขที่ตำแหน่งที่ต้องการ");
					}
				}
			}
		},
		{
			text: 'ยกเลิก',
			iconCls: 'arrow-undo',
			listeners: {
				click: function(){
					winTmp.hide();
				}
			}
		}
	]
});


//-----------------------------------------------------------------------
//-----------------------------------------------------------------------
function funcSearchPositionBlank(){
	GridStorePositionBlank.baseParams = {
		condition_id: cmbSearchPositionBlank.getValue(),
		query: txtSearchPositionBlank.getValue()
	};
	GridStorePositionBlank.load({
		params:{
			start: 0,
			limit: 100
		}
	});
}

var GridStorePositionBlank = new Ext.data.JsonStore({
	url: pre_url+'/cmd2/list_position_blank',
	root: 'Records',
	totalProperty: 'totalCount',
	idProperty: 'posid',
	fields: [
		"posid",
		"posname",
		"fullname"
	]
});

var GridPositionBlank = new Ext.grid.GridPanel({
	id: 'GridPositionBlank',
	title: '',
	frame: false,
	stripeRows: true,
	store: GridStorePositionBlank,
	viewConfig: {forceFit: true},
	loadMask: {
		msg: 'Please wait...'
	},
	columns: [
		new Ext.grid.RowNumberer(),
		{header: "เลขที่ตำแหน่ง",dataIndex: 'posid', width: 4, sortable: true},
		{header: "ตำแหน่ง",dataIndex: 'posname', width: 10, sortable: true}
	],
	listeners: {
		rowdblclick: function( me, rowIndex, e ){
			text2.setValue(me.selModel.selections.items[0].data.posid);
			winPositionBlank.hide();
			text2_get_position(text2);
		}
	},
	tbar: [
		'ค้นหาโดย : ',
		cmbSearchPositionBlank = new Ext.form.ComboBox({
			hiddenName: 'cmbSearchPositionBlank',
			mode: 'local',
			width: 200,
			triggerAction: 'all',
			valueField: 'condition_id',
			displayField: 'condition_text',
			store: new Ext.data.ArrayStore({
				fields: ['condition_id', 'condition_text'],
				data: [['1', 'ตำแหน่งสายงาน']]
			}),
			listeners: {
				select : function( me, record, index ) {
					funcSearchPositionBlank();
				}
			}
		}),
		'คำค้นหา : ',
		txtSearchPositionBlank = new Ext.form.TextField({
			id: 'txtSearchPositionBlank',
			width: 200,
			enableKeyEvents: true,
			listeners: {
				keypress: function( me, e ){
					if(e.keyCode == e.ENTER){
						funcSearchPositionBlank();
					}
				}
			}
		}),
		btnSearchPositionBlank = new Ext.Button({
			id: 'btnSearchPositionBlank',
			iconCls: 'zoom',
			text: '',
			listeners: {
				click: function(){
					funcSearchPositionBlank();
				}
			}
		})
	],
	bbar: new Ext.PagingToolbar({
		store: GridStorePositionBlank,
		pageSize: 100,
		displayInfo: true,
		displayMsg: 'รายการที่ {0} - {1} จากทั้งหมด {2}',
		emptyMsg: "ไม่มีข้อมูล"
	})
});

var winPositionBlank = new Ext.Window({
	title: 'ค้นหาตำแหน่งว่าง',
	iconCls: 'book-open',
	applyTo: 'div_window_position_blank',
	layout: 'fit',
	width: 550,
	height: 420,
	autoScroll: true,
	closeAction: 'hide',
	modal: true,
	items: [
		GridPositionBlank
	],
	buttons: [
		{
			text: 'ตกลง',
			iconCls: 'accept',
			formBind: true,
			listeners: {
				click: function(){
					if( GridPositionBlank.selModel.selections.items.length != 0 ){
						text2.setValue(GridPositionBlank.selModel.selections.items[0].data.posid);
						winPositionBlank.hide();
						text2_get_position(text2);
					} else {
						Ext.Msg.alert("Error", "กรุณาคลิกเลือกตำแหน่งว่างที่ต้องการ");
					}
				}
			}
		},
		{
			text: 'ยกเลิก',
			iconCls: 'arrow-undo',
			listeners: {
				click: function(){
					winPositionBlank.hide();
				}
			}
		}
	]
});