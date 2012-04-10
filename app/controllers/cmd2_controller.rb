# coding: utf-8
class Cmd2Controller < ApplicationController
    
    def list_position_blank
        start = params[:start].to_s
        limit = params[:limit].to_s
        condition_id = params[:condition_id].to_s
        query = params[:query].to_s
        
        sql = "SELECT
            pisj18.posid,
            coalesce(cposition.shortpre,'') || coalesce(cposition.posname,'') || ' ' || coalesce(cgrouplevel.clname,'') as posname,
            coalesce(cprefix.prefix,'') || coalesce(pispersonel.fname,'') || '  ' || coalesce(pispersonel.lname,'') AS fullname
            FROM pisj18
            LEFT JOIN cposition ON cposition.poscode=pisj18.poscode
            LEFT JOIN cgrouplevel ON cgrouplevel.ccode=pisj18.c
            LEFT JOIN pispersonel ON pispersonel.id=pisj18.id
            LEFT JOIN cprefix ON cprefix.pcode=pispersonel.pcode
            WHERE 1=1"
        
        if condition_id != ""
            
            case condition_id
            #when '1' #กรณีค้นหาด้วย ชื่อ-นามสกุลของผู้ครองตำแหน่ง
            #    if query != ""
            #        sql += " AND cprefix.prefix || pispersonel.fname || pispersonel.lname LIKE '%#{query}%'"
            #    end
            #    sql += " AND NOT(pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null))"
            when '1' #กรณีค้นหาด้วย ตำแหน่งสายงาน
                if query != ""
                    sql += " AND coalesce(cposition.shortpre,'') || coalesce(cposition.posname,'') || ' ' || coalesce(cgrouplevel.clname,'') LIKE '%#{query}%'"
                end
                #sql += " AND NOT(pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null))"
            #when '3' #กรณีค้นหาด้วยตำแหน่งว่าง จะไม่สนใจคำค้นหา มันจะแสดงตำแหน่งว่างทั้งหมดที่มี
                #sql += " AND pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null)"
            end
            
            #ทุกเงื่อนไขค้นหา จะต้องเอามาเฉพาะตำแหน่งว่างเท่านั้น
            sql += " AND pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null) order by posname"
        end
        
        rs = Pisj18.find_by_sql(sql)
        totalCount = rs.count()
        sql += " OFFSET #{start} LIMIT #{limit}"
        rs = Pisj18.find_by_sql(sql)
        
        return_data = {}
        return_data[:totalCount] = totalCount
        return_data[:Records]   = rs.collect{|u|{
            :posid => u.posid,
            :posname => u.posname,
            :fullname => u.fullname
          }
        }
        render :text => return_data.to_json,:layout => false
    end
    
    def move_to_tmp

        posid = params[:posid].to_s #เลขที่ตำแหน่ง
        id = params[:id].to_s #id ของคน
        
        begin
            Pisj18.transaction do
                #ทำให้ตำแหน่งว่างลงชั่วคราว แต่ยังไม่ต้องอัพเดตค่า emptydate
                sql = "update pisj18 set id='' where posid=#{posid}"
                rs = Pisj18.find_by_sql(sql)
                
                #คัดลอกตำแหน่งปัจจุบันไปเก็บไว้ที่ชั่วคราวก่อน
                sql = "update pispersonel set last_posid=posid where id='#{id}'"
                rs = Pispersonel.find_by_sql(sql)
                
                #ทำให้ตำแหน่งปัจจุบันเป็นค่าว่างเปล่า ซึ่งจะมีผลทำให้โปรแกรมเดิมจะค้นหาข้าราชการ และอดีตไม่เจอ
                sql = "update pispersonel set posid=null where id='#{id}'"
                rs = Pispersonel.find_by_sql(sql)

            end
            
            return_data = {}
            return_data[:success] = true
            render :text => return_data.to_json, :layout => false
        rescue
            return_data = {}
            return_data[:success] = false
            render :text => return_data.to_json, :layout => false
        end
    end
    
    def list_tmp
        
        sql = "SELECT pisj18.posid, cposition.shortpre, cposition.posname, cgrouplevel.clname,
            coalesce(cprefix.prefix,'') || coalesce(pispersonel.fname,'') || '  ' || coalesce(pispersonel.lname,'') AS fullname
            FROM pispersonel
            LEFT JOIN cprefix ON pispersonel.pcode=cprefix.pcode
            LEFT JOIN pisj18 ON pispersonel.last_posid=pisj18.posid
            LEFT JOIN cposition ON pisj18.poscode=cposition.poscode
            LEFT JOIN cgrouplevel ON pisj18.c=cgrouplevel.ccode
            WHERE pispersonel.posid is null ORDER BY fullname"
        
        rs = Pispersonel.find_by_sql(sql)
        #totalCount = rs.count()
        
        return_data = {}
        #return_data[:totalCount] = totalCount
        return_data[:Records]   = rs.collect{|u|{
            :posid => u.posid,
            :posname => "#{u.shortpre}#{u.posname} #{u.clname}",
            :fullname => u.fullname
          }
        }
        render :text => return_data.to_json,:layout => false
    end
    
    def list_position
        start = params[:start].to_s
        limit = params[:limit].to_s
        condition_id = params[:condition_id].to_s
        query = params[:query].to_s
        
        sql = "SELECT pisj18.posid, cposition.shortpre, cposition.posname, cgrouplevel.clname, 
            coalesce(cprefix.prefix,'') || coalesce(pispersonel.fname,'') || '  ' || coalesce(pispersonel.lname,'') AS fullname, 
            pispersonel.id as xxx
            FROM pisj18
            LEFT JOIN cposition ON cposition.poscode=pisj18.poscode
            LEFT JOIN cgrouplevel ON cgrouplevel.ccode=pisj18.c
            LEFT JOIN pispersonel ON pispersonel.id=pisj18.id
            LEFT JOIN cprefix ON cprefix.pcode=pispersonel.pcode
            WHERE 1=1"
        
        if condition_id != ""
            
            case condition_id
            when '1' #กรณีค้นหาด้วย ชื่อ-นามสกุลของผู้ครองตำแหน่ง
                if query != ""
                    sql += " AND coalesce(cprefix.prefix,'') || coalesce(pispersonel.fname,'') || coalesce(pispersonel.lname,'') LIKE '%#{query}%'"
                end
                sql += " AND NOT(pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null))"
            when '2' #กรณีค้นหาด้วย ตำแหน่งสายงาน
                if query != ""
                    sql += " AND coalesce(cposition.posname,'') || coalesce(cgrouplevel.clname,'') LIKE '%#{query}%'"
                end
                sql += " AND NOT(pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null))"
            end
        end
        
        rs = Cjob.find_by_sql(sql)
        totalCount = rs.count()
        sql += " OFFSET #{start} LIMIT #{limit}"
        rs = Cjob.find_by_sql(sql)
        
        return_data = {}
        return_data[:totalCount] = totalCount
        return_data[:Records]   = rs.collect{|u|{
            :posid => u.posid,
            :posname => "#{u.shortpre}#{u.posname} #{u.clname}",
            :fullname => u.fullname,
            :id => u.xxx
          }
        }
        render :text => return_data.to_json,:layout => false
    end
    
    def list_place_dialog
        start = params[:start].to_s
        limit = params[:limit].to_s
        provcode = params[:provcode].to_s
        query = params[:query].to_s
        
        sql = "SELECT csubdept.sdcode, coalesce(csubdept.shortpre,'') || coalesce(csubdept.subdeptname,'') || ' ' || coalesce(camphur.shortpre,'') ||
            coalesce(camphur.amname,'') || ' ' || coalesce(cprovince.shortpre,'') || coalesce(cprovince.provname,'') AS fullsubdeptname
            FROM csubdept
            JOIN camphur ON csubdept.amcode=camphur.amcode AND csubdept.provcode=camphur.provcode
            JOIN cprovince ON csubdept.provcode=cprovince.provcode
            WHERE 1=1"
        
        if provcode != ""
            sql += " AND cprovince.provcode=#{provcode}"
        end
        
        if query != ""
            sql += " AND coalesce(csubdept.shortpre,'') || coalesce(csubdept.subdeptname,'') || ' ' || coalesce(camphur.shortpre,'') ||
            coalesce(camphur.amname,'') || ' ' || coalesce(cprovince.shortpre,'') || coalesce(cprovince.provname,'') LIKE '%#{query}%'"
        end
        
        rs = Cjob.find_by_sql(sql)
        totalCount = rs.count()
        sql += " ORDER BY fullsubdeptname OFFSET #{start} LIMIT #{limit}"
        rs = Cjob.find_by_sql(sql)
        
        return_data = {}
        return_data[:totalCount] = totalCount
        return_data[:Records]   = rs.collect{|u|{
            :sdcode => u.sdcode,
            :fullsubdeptname => u.fullsubdeptname
        }}
        render :text => return_data.to_json,:layout => false
    end
    
    def get_place
        id = params[:id]
        sql = "SELECT coalesce(csubdept.shortpre,'') || coalesce(csubdept.subdeptname,'') || ' ' || coalesce(camphur.shortpre,'') ||
            coalesce(camphur.amname,'') || ' ' || coalesce(cprovince.shortpre,'') || coalesce(cprovince.provname,'') AS fullsubdeptname
            FROM csubdept
            JOIN camphur ON csubdept.amcode=camphur.amcode AND csubdept.provcode=camphur.provcode
            JOIN cprovince ON csubdept.provcode=cprovince.provcode
            WHERE csubdept.sdcode=#{id}"
        
        rs = Cjob.find_by_sql(sql)
        
        return_data = {}
        return_data[:Records]   = rs.collect{|u|{
            :fullsubdeptname => u.fullsubdeptname
        }}
        render :text => return_data.to_json,:layout => false
        
    end
    
    def get_position
        posid = params[:posid]
        if posid == ""
            posid = 0
        end
        sql = "SELECT pisj18.poscode, pisj18.excode, pisj18.c AS ccode, pisj18.epcode, pisj18.ptcode, pisj18.mincode, 
            pisj18.deptcode, pisj18.dcode, pisj18.sdcode, pisj18.seccode, pisj18.jobcode, pisj18.salary,
            coalesce(csubdept.shortpre,'') || coalesce(csubdept.subdeptname,'') || ' ' || coalesce(camphur.shortpre,'') ||
            coalesce(camphur.amname,'') || ' ' || coalesce(cprovince.shortpre,'') || coalesce(cprovince.provname,'') AS fullsubdeptname,
            trim(coalesce(cprefix.prefix,'') || coalesce(pispersonel.fname,'') || '  ' || coalesce(pispersonel.lname,'')) as fullname
            FROM pisj18 
            left JOIN csubdept ON pisj18.sdcode=csubdept.sdcode
            left JOIN camphur ON csubdept.amcode=camphur.amcode AND csubdept.provcode=camphur.provcode
            left JOIN cprovince ON csubdept.provcode=cprovince.provcode
            left JOIN pispersonel ON pisj18.posid=pispersonel.posid and pisj18.id=pispersonel.id
            left JOIN cprefix ON pispersonel.pcode=cprefix.pcode
            WHERE pisj18.posid=#{posid} "
        
        #ต้องเป็นตำแหน่งว่างเท่านั้น
        sql += " AND pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null)"
        
        rs = Pisj18.find_by_sql(sql)
        
        return_data = {}
        return_data[:Records]   = rs.collect{|u|{
            :poscode => u.poscode,
            :excode => u.excode,
            :ccode => u.ccode,
            :epcode => u.epcode,
            :ptcode => u.ptcode,
            :mincode => u.mincode,
            :deptcode => u.deptcode,
            :dcode => u.dcode,
            :sdcode => u.sdcode,
            :seccode => u.seccode,
            :jobcode => u.jobcode,
            :salary => u.salary,
            :fullsubdeptname => u.fullsubdeptname,
            :fullname => u.fullname
        }}
        render :text => return_data.to_json,:layout => false
        
    end
    
    def get_olddata
        posid = params[:posid]
        if posid == ""
            posid = 0
        end
        
        sql = "select pispersonel.id, 
        coalesce(cprefix.prefix,'') || coalesce(pispersonel.fname,'') || '  ' || coalesce(pispersonel.lname,'') as fullname,
        coalesce(cposition.shortpre,'') || coalesce(cposition.posname,'') as posname,
        cgrouplevel.cname,
        pisj18.salary,
        coalesce(cexecutive.shortpre,'') || coalesce(cexecutive.exname,'') as exname,
        coalesce(cexpert.prename,'') || coalesce(cexpert.expert,'') as expert,
        cpostype.ptname,
        cdivision.division,
        coalesce(csubdept.shortpre,'') || coalesce(csubdept.subdeptname,'') || ' ' || coalesce(camphur.shortpre,'') ||
        coalesce(camphur.amname,'') || ' ' || coalesce(cprovince.shortpre,'') || coalesce(cprovince.provname,'') AS fullsubdeptname,
        csubsdcode.subsdname,
        coalesce(csection.shortname,'') || coalesce(csection.secname,'') as secname,
        cjob.jobname
        from pisj18 left join 
        pispersonel on pisj18.posid=pispersonel.last_posid left join 
        cprefix on pispersonel.pcode=cprefix.pcode left join 
        cposition on pisj18.poscode=cposition.poscode left join 
        cgrouplevel on pisj18.c=cgrouplevel.ccode left join 
        cexecutive on pisj18.excode=cexecutive.excode left join 
        cexpert on pisj18.epcode=cexpert.epcode left join 
        cpostype on pisj18.ptcode=cpostype.ptcode left join 
        cdivision on pisj18.dcode=cdivision.dcode left join 
        csubdept on pisj18.sdcode=csubdept.sdcode left join 
        camphur on csubdept.amcode=camphur.amcode and csubdept.provcode=camphur.provcode left join 
        cprovince on csubdept.provcode=cprovince.provcode left join 
        csubsdcode on pisj18.subdcode=csubsdcode.subsdcode left join 
        csection on pisj18.seccode=csection.seccode left join 
        cjob on pisj18.jobcode=cjob.jobcode 
        where 1=1
        and pisj18.posid=#{posid} and pispersonel.pstatus='1'"
        
        rs = Pisj18.find_by_sql(sql)
        
        id = ""
        if rs.count() > 0
            id = rs[0].id
        end
        
        sql2 = "select 
        pispersonel.j18code, cdept.deptname, cdivision.division,
        coalesce(csubdept.shortpre,'') || coalesce(csubdept.subdeptname,'') || ' ' || coalesce(camphur.shortpre,'') ||
        coalesce(camphur.amname,'') || ' ' || coalesce(cprovince.shortpre,'') || coalesce(cprovince.provname,'') AS fullsubdeptname,
        csubsdcode.subsdname, coalesce(csection.shortname,'') || coalesce(csection.secname,'') as secname, cjob.jobname
        from pispersonel left join 
        cdept on pispersonel.deptcode=cdept.deptcode left join 
        cdivision on pispersonel.dcode=cdivision.dcode left join 
        csubdept on pispersonel.sdcode=csubdept.sdcode left join 
        camphur on csubdept.amcode=camphur.amcode and csubdept.provcode=camphur.provcode left join 
        cprovince on csubdept.provcode=cprovince.provcode left join 
        csubsdcode on pispersonel.subdcode=csubsdcode.subsdcode left join 
        csection on pispersonel.seccode=csection.seccode left join 
        cjob on pispersonel.jobcode=cjob.jobcode 
        where 1=1 
        and pispersonel.id='#{id}'"
        rs2 = Pispersonel.find_by_sql(sql2)
        
        return_data = {}
        return_data[:Records]   = rs.collect{|u|{
            :id => u.id,
            :fullname => u.fullname,
            :posname => u.posname,
            :cname => u.cname,
            :salary => u.salary,
            :exname => u.exname,
            :expert => u.expert,
            :ptname => u.ptname,
            :division => u.division,
            :fullsubdeptname => u.fullsubdeptname,
            :subsdname => u.subsdname,
            :secname => u.secname,
            :jobname => u.jobname
        }}
        return_data[:Records2]   = rs2.collect{|u|{
            :j18code => u.j18code,
            :deptname => u.deptname,
            :division => u.division,
            :fullsubdeptname => u.fullsubdeptname,
            :subsdname => u.subsdname,
            :secname => u.secname,
            :jobname => u.jobname
        }}
        render :text => return_data.to_json,:layout => false
        
    end

    def save
        posid_old = params[:posid_old].to_s
        hid_id = params[:hid_id].to_s
        
        updcode = params[:updcode].to_s #การเคลื่อนไหว
        refcmnd = params[:refcmnd].to_s #คำสั่ง
        forcedate = params[:forcedate][0,10].to_s #วันที่มีผลบังคับใช้

        posid = params[:posid].to_s #เลขที่ตำแหน่ง
        
        j18code = params[:j18code].to_s #ปฏิบัติงานตรง จ.18
        poscode = params[:poscode].to_s #ตำแหน่งสายงาน
        c = params[:c].to_s #ระดับ
        salary = params[:salary].to_s #เงินเดือน
        excode = params[:excode].to_s #ตำแหน่งบริหาร
        epcode = params[:epcode].to_s #ความเชี่ยวชาญ
        ptcode = params[:ptcode].to_s #ว./วช./ชช.
        #mincode = params[:mincode] #กระทรวง
        #deptcode = params[:deptcode] #กรม
        dcode = params[:dcode].to_s #กอง
        sdcode = params[:sdcode].to_s #รหัสหน่วยงาน
        subdcode = params[:subdcode].to_s #กลุ่มภารกิจ
        seccode = params[:seccode].to_s #ฝ่าย /กลุ่มงาน
        jobcode = params[:jobcode].to_s #งาน
        fullname = params[:fullname].to_s #ชื่อหน่วยงานแบบเต็ม

        note = params[:note].to_s #หมายเหตุ
        

        #หาการเรียงลำดับของคอลัมน์ historder
        sql = "select id, historder as num from pisposhis where id='#{hid_id}' order by historder desc"
        rs = Pisposhis.find_by_sql(sql)
        historder = 1
        if rs.count() > 0
            historder = rs[0].num.to_i + 1
        end
        
        #หาเงินเดือนของ ถือจ่ายปีปัจจุบัน
        sql = "select nowsal from pisj18 where posid=#{posid}"
        rs = Pisj18.find_by_sql(sql)
        nowsal = rs[0].nowsal
        
        begin
            
            Pisj18.transaction do
                
                #อัพเดตตาราง pisj18 โดยทำให้ตำแหน่งเก่าเป็นตำแหน่งว่างก่อน
                sql = "update pisj18 set
                    id='',
                    emptydate='#{forcedate}' 
                    where posid=#{posid_old}"
                
                rs = Pisj18.find_by_sql(sql)
                
                
                #เพิ่มประวัติคน
                rs3 = Pisposhis.new
                rs3.id = hid_id
                rs3.historder = historder
                rs3.forcedate = forcedate
                rs3.poscode = poscode
                rs3.excode = excode
                rs3.epcode = epcode
                rs3.mcode = 10
                rs3.dcode = dcode
                rs3.deptcode = 10
                rs3.sdcode = sdcode
                rs3.seccode = seccode
                rs3.jobcode = jobcode
                rs3.updcode = updcode
                rs3.posid = posid
                rs3.c = c
                rs3.salary = salary
                rs3.refcmnd = refcmnd
                rs3.ptcode = ptcode
                rs3.note = note
                rs3.save!
                
                
                #อัตเดตตารางบุคคล
                if dcode == "" 
                    dcode = "null"
                end
                
                if sdcode == "" 
                    sdcode = "null"
                end
                
                if subdcode == "" 
                    subdcode = "null"
                end
                
                if seccode == "" 
                    seccode = "null"
                end
                
                if jobcode == "" 
                    jobcode = "null"
                end
                
                if poscode == "" 
                    poscode = "null"
                end
                
                if excode == "" 
                    excode = "null"
                end
                
                if epcode == "" 
                    epcode = "null"
                end
                
                if c == "" 
                    c = "null"
                end
                
                if salary == "" 
                    salary = "null"
                end
                
                if j18code == "" 
                    j18code = "null"
                end
                
                if ptcode == "" 
                    ptcode = "null"
                end
                
                sql = "update pispersonel set
                    posid=#{posid},
                    sdcode=#{sdcode}, 
                    seccode=#{seccode}, 
                    jobcode=#{jobcode}, 
                    poscode=#{poscode}, 
                    excode=#{excode}, 
                    epcode=#{epcode}, 
                    c=#{c}, 
                    salary=#{salary}, 
                    j18code=#{j18code},
                    dcode=#{dcode},
                    subdcode=#{subdcode}, 
                    note='#{note}', 
                    ptcode=#{ptcode} 
                    where id='#{hid_id}'"
                rs = Pispersonel.find_by_sql(sql)
                
                
                #อัพเดตตาราง pisj18 โดยเอาคนเดิมย้ายไปตำแหน่งใหม่
                sql = "update pisj18 set id='#{hid_id}', rem='#{note}', emptydate=null, posmny=null"
                
                if salary.to_i > nowsal.to_i
                    #ถ้าเงินเดือนที่บรรจุมากกว่า  >> ถือจ่ายปัจจุบัน.  Update nowc, nowsal ,c ,salary. อาศัยเบิกปีก่อน is null
                    sql += ", c=#{c}, salary=#{salary}, nowc=#{c}, nowsal=#{salary}, nowcasb=null, nowsalasb=null"
                end
                if salary.to_i < nowsal.to_i 
                    #ถ้าเงินเดือนที่บรรจุน้อยกว่า >> update nowcasb,nowsal abs ,c, salary
                    sql += ", c=#{c}, salary=#{salary}, nowcasb=#{c}, nowsalasb=#{salary}"
                end
                
                sql += ", poscode=#{poscode}, excode=#{excode}, 
                jobcode=#{jobcode}, epcode=#{epcode}, dcode=#{dcode}, seccode=#{seccode}, ptcode=#{ptcode},
                subdcode=#{subdcode}, sdcode=#{sdcode}"
                sql += " where posid=#{posid}"
                rs = Pisj18.find_by_sql(sql)

            end
            
            return_data = {}
            return_data[:success] = true
            render :text => return_data.to_json, :layout => false
        rescue
            return_data = {}
            return_data[:success] = false
            render :text => return_data.to_json, :layout => false
        end
    end
end
