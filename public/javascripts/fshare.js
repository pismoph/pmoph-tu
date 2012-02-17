pre_url = "";
Date.monthNames = ['ม.ค','ก.พ','มี.ค','เม.ย','พ.ค','มิ.ย','ก.ค','ส.ค','ก.ย','ต.ค','พ.ย','ธ.ค'];
var loadMask = new Ext.LoadMask(Ext.getBody(), {msg:"Please wait..."});	
var rowNumberer = function(value, p, record) {
    var ds = record.store
    var i = (ds.lastOptions != null && ds.lastOptions.params)? ds.lastOptions.params.start:0;
    if (isNaN ( i )) {
            i = 0;
    }
    return ds.indexOf(record)+i+1;
};
cur_ref = "";
var mainMenu = new Ext.Toolbar({
    region:'north'
    ,height: 30
    ,items: [
        {
             text: "รหัสข้อมูล"
            ,menu: {
                items: [
                    {
                        text: "ตำแหน่งข้าราชการ"
                        ,handler: function(){
                            return false;
                        }
                        ,menu: {
                            items: [
                                {
                                    text: "ตำแหน่งสายงานข้าราชการ"
                                    ,handler: function(){
                                        cur_ref = "position";
                                        Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cposition.js','initCode');
                                    }
                                }
                                ,{
                                    text: "ตำแหน่งบริหาร"
                                    ,handler: function (){
                                            cur_ref = "executive";
                                            Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cexecutive.js','initCode');
                                    }
                                }
                                ,{
                                        text: "ความเชี่ยวชาญ"
                                        ,handler: function (){
                                                cur_ref = "expert";
                                                Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cexpert.js','initCode');
                                        }
                                }
                                ,{
                                        text: "ว. / วช. / ชช."
                                        ,handler: function (){
                                                cur_ref = "postype";
                                                Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cpostype.js','initCode');
                                        }
                                }
                                ,{
                                        text: "กลุ่ม / ระดับ"
                                        ,handler: function (){
                                                cur_ref = "grouplevel";
                                                Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cgrouplevel.js','initCode');
                                        }
                                }
                            ]
                        }
                    }
                    ,{
                            text: "ตำแหน่งลูกจ้างประจำ"
                            ,handler: function(){
                                return false;
                            }
                            ,menu: {
                                    items: [
                                            {
                                                    text: "กลุ่ม"
                                                    ,handler: function (){
                                                            cur_ref = "epngroup";
                                                            Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cepngroup.js','initCode');
                                                    }
                                            },{
                                                    text: "หมวด"
                                                    ,handler: function (){
                                                            cur_ref = "epnsubgroup";
                                                            Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cepnsubgroup.js','initCode');
                                                    }
                                            },{
                                                    text: "ตำแหน่งลูกจ้างประจำ"
                                                    ,handler: function (){
                                                            cur_ref = "epnposwork";
                                                            Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cepnposwork.js','initCode');
                                                    }
                                            }
                                    ]
                            }
                    }
                    ,{
                            text: "รหัสการเคลื่อนไหว"
                            ,handler: function (){
                                    cur_ref = "update";
                                    Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cupdate.js','initCode');
                            }
                    }
                    ,{
                            text: "สถานะตาม จ. 18"
                            ,handler: function (){
                                    cur_ref = 'code_j18status'
                                    Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cj18status.js','initCode');
                            }							
                    }
                    ,{
                        text: "หน่วยงาน"
                        ,handler: function(){
                            return false;
                        }
                        ,menu: {
                            items: [
                                {
                                    text: "กระทรวง"
                                    ,handler: function(){
                                        cur_ref = 'code_ministry'
                                        Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cministry.js','initCode');                                        
                                    }
                                }
                                ,{
                                    text: "กรม"                                    
                                    ,handler: function(){
                                        cur_ref = 'code_dept'
                                        Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cdept.js','initCode');                                        
                                    }
                                }
                                ,{
                                    text: "กอง"                                    
                                    ,handler: function(){
                                        cur_ref = 'code_division'
                                        Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cdivision.js','initCode');                                        
                                    }
                                }
                                ,{
                                    text: "หน่วยงาน"                                    
                                    ,handler: function(){
                                        cur_ref = 'code_subdept'
                                        Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/csubdept.js','initCode');                                        
                                    }
                                }
                                ,{
                                    text: "ฝ่าย/กลุ่มงาน"
                                    ,handler: function(){
                                        cur_ref = 'code_section'
                                        Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/csection.js','initCode');                                        
                                    }
                                }
                                ,{
                                    text: "งาน"
                                    ,handler: function(){
                                        cur_ref = 'code_job'
                                        Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cjob.js','initCode');                                        
                                    }
                                }
                            ]
                        }
                    }
                    ,{
                        text: "พื้นที่"
                        ,handler: function(){
                            return false;
                        }
                        ,menu: {
                            items: [
                                {
                                    text: "ประเทศ"                                    
                                    ,handler: function(){
                                        cur_ref = 'code_country'
                                        Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/ccountry.js','initCode');                                        
                                    }
                                }
                                ,{
                                    text: "เขต"                                    
                                    ,handler: function(){
                                        cur_ref = 'code_area'
                                        Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/carea.js','initCode');                                        
                                    }
                                }
                                ,{
                                    text: "จังหวัด"                                    
                                    ,handler: function(){
                                        cur_ref = 'code_province'
                                        Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cprovince.js','initCode');                                        
                                    }
                                }
                                ,{
                                    text: "อำเภอ"                                    
                                    ,handler: function(){
                                        cur_ref = 'code_amphur'
                                        Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/camphur.js','initCode');                                        
                                    }
                                }
                                ,{
                                    text: "ตำบล"                                    
                                    ,handler: function(){
                                        cur_ref = 'code_tumbon'
                                        Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/ctumbon.js','initCode');                                        
                                    }
                                }
                            ]
                        }                                    
                    }
                    ,{
                        text: "ข้อมูลส่วนตัว"
                        ,handler: function(){
                            return false;
                        }
                        ,menu: {
                            items: [
                                {
                                    text: "คำนำหน้าชื่อ"
                                    ,handler: function (){
                                            cur_ref = "prefix";
                                            Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cprefix.js','initCode');
                                    }
                                }
                                ,{
                                    text: "สถานะภาพสมรส"
                                    ,handler: function (){
                                            cur_ref = "marital";
                                            Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cmarital.js','initCode');
                                    }
                                }
                                ,{
                                    text: "ศาสนา"
                                    ,handler: function (){
                                            cur_ref = "religion";
                                            Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/crelig.js','initCode');
                                    }
                                }
                                ,{
                                    text: "การศึกษา"
                                    ,handler: function(){
                                        return false;
                                    }
                                    ,menu: {
                                        items: [
                                            {
                                                text: "วุฒิการศึกษา"
                                                ,handler: function (){
                                                        cur_ref = "qualify";
                                                        Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cqualify.js','initCode');
                                                }
                                            }
                                            ,{
                                                    text: "ระดับการศึกษา"
                                                    ,handler: function (){
                                                            cur_ref = "edulevel";
                                                            Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cedulevel.js','initCode');
                                                    }
                                            }
                                            ,{
                                                    text: "สาขาวิชาเอก"
                                                    ,handler: function (){
                                                            cur_ref = "major";
                                                            Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cmajor.js','initCode');
                                                    }
                                            }
                                            ,{
                                                    text: "ใบอนุญาตประกอบวิชาชีพ"
                                                    ,handler: function (){
                                                            cur_ref = 'code_trade'
                                                            Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/ctrade.js','initCode');
                                                    }							
                                            }
                                        ]
                                    }
                                }
                            ]
                        }
                    }
                    ,{
                            text: "การลงโทษทางวินัย"
                            ,handler: function (){
                                    cur_ref = "punish";
                                    Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cpunish.js','initCode');
                            }
                    }
                    ,{
                            text: "เครื่องราชอิสริยาภรณ์"
                            ,handler: function (){
                                    cur_ref = "code_decoratype";
                                    Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cdecoratype.js','initCode');
                            }
                    }
                    ,{
                            text: "ประเภทการลา"
                            ,handler: function (){
                                    cur_ref = "absenttype";
                                    Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/code/cabsenttype.js','initCode');
                            }
                    }
                ]
            }
        },
        {
            text: "ข้อมูลบุคคล"
            ,menu: {
                items:[
                    {
                        text: "ข้าราชการ"
                        ,handler: function(){
                            loadMask.show();
                            cur_ref = 'tab_pasonel';
                            Ext.ux.OnDemandLoad.load(pre_url + '/javascripts/person_info/tab_personel.js',"initInfo");
                        }
                    }	
                ]
            }
        },
        {
            text: "บันทึกคำสั่ง"
            ,menu: {
                items: [
                    {
                        text: "คำสั่งบรรจุ / รับย้าย / รับโอน"
                        ,handler: function(){
                            loadMask.show();
                            cur_ref = "cmd1";
                            Ext.ux.OnDemandLoad.load(pre_url+"/javascripts/command/cmd1.js","initCmd");
                        }
                    },
                    {
                        text: "คำสั่งย้าย / เลื่อนภายในหน่วยงาน"
                        ,handler: function(){
                            loadMask.show();
                            cur_ref = "cmd2";
                            Ext.ux.OnDemandLoad.load(pre_url+"/javascripts/command/cmd2.js","initCmd");
                        }
                    },
                    {
                        text: "คำสั่งปฏิบัติราชการ"
                        ,handler: function(){
                            loadMask.show();
                            cur_ref = "cmd3";
                            Ext.ux.OnDemandLoad.load(pre_url+"/javascripts/command/cmd3.js","initCmd");
                        }
                    },
                    {
                        text: "แก้ไขคำสั่ง"
                        ,handler: function(){
                            loadMask.show();
                            cur_ref = "cmd4";
                            Ext.ux.OnDemandLoad.load(pre_url+"/javascripts/command/cmd4.js","initCmd");
                        }
                    },
                    {
                        text: "คำสั่งย้ายออกนอกหน่วยงาน / ลาออก / เกษียณอายุ / ตาย"
                        ,handler: function(){
                            loadMask.show();
                            cur_ref = "cmd5";
                            Ext.ux.OnDemandLoad.load(pre_url+"/javascripts/command/cmd5.js","initCmd");
                        }
                    },
                    "-",
                    {
                        text: "คำนวณเงินสำหรับใช้ในการเลื่อนเงินเดือน"
                        ,handler: function(){
                            loadMask.show();
                            cur_ref = "calc_up_salary";
                            Ext.ux.OnDemandLoad.load(pre_url+"/javascripts/command/calc_up_salary.js","initCmd");
                        }
                    },
                    {
                        text: "กำหนดกลุ่มบริหารวงเงินให้หน่วยงาน"
                        ,handler: function(){
                            loadMask.show();
                            cur_ref = "calc_up_salary";
                            Ext.ux.OnDemandLoad.load(pre_url+"/javascripts/command/calc_up_salary.js","initCmd");
                        }
                    },
                    {
                        text: "กำหนดบุคคล-การบริหารวงเงิน"
                        ,handler: function(){
                            loadMask.show();
                            cur_ref = "calc_up_salary";
                            Ext.ux.OnDemandLoad.load(pre_url+"/javascripts/command/calc_up_salary.js","initCmd");
                        }
                    }
                ]
            }
        },
        {
            text: "รายงาน"
            ,menu: {
            items: [
                {
                text: "ราชชื่อผู้ที่เกษียณอายุในปีที่ระบุ"
                ,handler: function(){
                    loadMask.show();
                    cur_ref = 'retire';
                    Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/report/retire.js',"initReport");
                }
                }
                ,{
                text: "จำนวนข้าราชการจำแนกตามตำแหน่งสายงาน-ระดับ"
                ,handler: function(){
                    loadMask.show();
                    cur_ref = 'position_level';
                    Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/report/position_level.js',"initReport");
                }
                }
                ,{
                text: "จำนวนตำแหน่งสายงานข้าราชการจำแนกตามหน่วยงาน(จ.18)"
                ,handler: function(){
                    loadMask.show();
                    cur_ref = 'position_work_place';
                    Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/report/position_work_place.js',"initReport");
                }
                }
                ,{
                text: "ข้าราชการจำแนกตามตำแหน่งสายงาน-ระดับ"
                ,handler: function(){
                    loadMask.show();
                    cur_ref = 'list_position_level';
                    Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/report/list_position_level.js',"initReport");
                }
                }
                ,{
                text: "ข้าราชการจำแนกตามหน่วยงาน"
                ,handler: function(){
                    loadMask.show();
                    cur_ref = 'work_place';
                    Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/report/work_place.js',"initReport");
                }
                }
            ]
            }
        },
        {
            text: "สอบถามข้อมูล"
            ,menu: {
            items: [
                {
                        text: "ข้อมูลตำแหน่ง(จ. 18)"
                        ,handler	: function (){
                                loadMask.show();         
                                cur_ref = "search";
                                Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/search/searchj18.js','initInfo');
                        }
                },{
                        text: "ปฏิบัติราชการปัจจุบัน/ข้อมูลส่วนตัว"
                        ,handler	: function (){
                                loadMask.show();         
                                cur_ref = "search";
                                Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/search/search_perform_person.js','initInfo');
                        }
                },{
                        text: "ประวัติการดำรงตำแหน่ง"
                        ,handler	: function (){
                                loadMask.show();         
                                cur_ref = "search";
                                Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/search/search_poshist.js','initInfo');
                        }
                },{
                        text: "ประวัติการรับพระราชทานเครื่องราชอิสริยาภรณ์"
                        ,handler	: function (){
                                loadMask.show();         
                                cur_ref = "search";
                                Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/search/search_insig.js','initInfo');
                        }
                        
                },{
                        text: "ประวัติการรศึกษา"
                        ,handler	: function (){
                                loadMask.show();         
                                cur_ref = "search";
                                Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/search/search_education.js','initInfo');
                        }
                        
                },{
                        text: "ประวัติการประชุม/อบรม/สัมมนา"
                        ,handler: function (){
                                loadMask.show();         
                                cur_ref = "search";
                                Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/search/search_trainning.js','initInfo');
                        }
                        
                },{
                        text: "โทษทางวินัย"
                        ,handler: function (){
                                loadMask.show();         
                                cur_ref = "search";
                                Ext.ux.OnDemandLoad.load(pre_url+'/javascripts/search/search_punish.js','initInfo');
                        }
                        
                }
            ]
            }
        },
        {
            text: "ผู้ใช้งาน"
            ,handler: function(){
                loadMask.show();
                cur_ref = 'user';
                Ext.ux.OnDemandLoad.load(pre_url + '/javascripts/manage_user/main.js',"initInfo");
            }
        }
    ]
});

////////////////////////////////////////////////////////////////////////////////////////////////////



function initCmd(){   
    obj = Ext.getCmp('mainCenter');
    obj.removeAll();
    if (cur_ref == 'test'){
        obj.add(mypanel);
        obj.getLayout().setActiveItem(mypanel);
        loadMask.hide();
    }
    if (cur_ref == 'cmd1'){
        obj.add(frmAddEdit);
        obj.getLayout().setActiveItem(frmAddEdit);
        loadMask.hide();
    }
    if (cur_ref == 'cmd2'){
        obj.add(frmAddEdit);
        obj.getLayout().setActiveItem(frmAddEdit);
        loadMask.hide();
    }
    if (cur_ref == 'cmd3'){
        obj.add(frmAddEdit);
        obj.getLayout().setActiveItem(frmAddEdit);
        loadMask.hide();
    }
    if (cur_ref == 'cmd4'){
        obj.add(frmAddEdit);
        obj.getLayout().setActiveItem(frmAddEdit);
        loadMask.hide();
    }
    if (cur_ref == 'cmd5'){
        obj.add(frmAddEdit);
        obj.getLayout().setActiveItem(frmAddEdit);
        loadMask.hide();
    }
}



