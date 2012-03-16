class Cmd4Controller < ApplicationController
    skip_before_filter :verify_authenticity_token

    #---------------------------------------------------------------------------
    
    #กรณีคำสั่งที่ 4 นี้ list_position จะหมายถึงค้นหาเพื่อต้องการผลลัพธ์ที่เป็นตำแหน่งข้าราชการปัจจุบัน
    def list_position
        start = params[:start].to_s
        limit = params[:limit].to_s
        condition_id = params[:condition_id].to_s
        query = params[:query].to_s
        
        sql = "SELECT pisj18.posid, cposition.shortpre, cposition.posname, cgrouplevel.clname,
            cprefix.prefix || pispersonel.fname || '  ' || pispersonel.lname AS fullname,
            pispersonel.id
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
                    sql += " AND cprefix.prefix || pispersonel.fname || pispersonel.lname LIKE '%#{query}%'"
                end
            when '2' #กรณีค้นหาด้วย ตำแหน่งสายงาน
                if query != ""
                    sql += " AND cposition.posname || cgrouplevel.clname LIKE '%#{query}%'"
                end
            end
        end
        sql += " AND NOT(pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null)) ORDER BY pisj18.posid"
        
        rs = Pisj18.find_by_sql(sql)
        totalCount = rs.count()
        sql += " OFFSET #{start} LIMIT #{limit}"
        rs = Pisj18.find_by_sql(sql)
        
        return_data = {}
        return_data[:totalCount] = totalCount
        return_data[:Records]   = rs.collect{|u|{
            :posid => u.posid,
            :posname => "#{u.shortpre}#{u.posname} #{u.clname}",
            :fullname => u.fullname,
            :id => u.id
          }
        }
        render :text => return_data.to_json,:layout => false
    end
    
    def get_position
        posid = params[:posid]
        
        sql = "SELECT pisj18.poscode, pisj18.excode, pisj18.c AS ccode, pisj18.epcode, pisj18.ptcode, pisj18.mincode, 
            pisj18.deptcode, pisj18.dcode, pisj18.sdcode, pisj18.seccode, pisj18.jobcode, pisj18.salary,
            csubdept.shortpre || csubdept.subdeptname|| ' ' || camphur.shortpre || camphur.amname || ' ' || cprovince.shortpre || cprovince.provname AS fullsubdeptname,
            cprefix.prefix || pispersonel.fname || '  ' || pispersonel.lname as fullname, pispersonel.j18code, pispersonel.note, pispersonel.id
            FROM pisj18 
            JOIN csubdept ON pisj18.sdcode=csubdept.sdcode
            JOIN camphur ON csubdept.amcode=camphur.amcode AND csubdept.provcode=camphur.provcode
            JOIN cprovince ON csubdept.provcode=cprovince.provcode
            JOIN pispersonel ON pisj18.posid=pispersonel.posid
            JOIN cprefix ON pispersonel.pcode=cprefix.pcode
            WHERE pispersonel.posid='#{posid}' AND pstatus='1'"
        #ต้องเป็นตำแหน่งที่มีคนบรรจุเท่านั้น
        sql += " AND NOT(pisj18.flagupdate='1' and (length(trim(pisj18.id))=0 or pisj18.id is null))"
        
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
            :fullname => u.fullname,
            :j18code => u.j18code,
            :note => u.note,
            :id => u.id
        }}
        render :text => return_data.to_json,:layout => false
        
    end
    
    def list_command
        id = params[:id]
        
        sql = "select pisposhis.id, pisposhis.historder, pisposhis.forcedate, pisposhis.poscode, pisposhis.excode, pisposhis.epcode, pisposhis.mcode, pisposhis.dcode, pisposhis.deptcode, pisposhis.sdcode,
            pisposhis.seccode, pisposhis.jobcode, pisposhis.hmcode, pisposhis.updcode, pisposhis.posid, pisposhis.c, pisposhis.salary, pisposhis.refcmnd, pisposhis.note,
            csubdept.shortpre || csubdept.subdeptname|| ' ' || camphur.shortpre || camphur.amname || ' ' || cprovince.shortpre || cprovince.provname as fullsubdeptname
            from pisposhis
            join pisj18 on pisposhis.posid=pisj18.posid
            join csubdept on pisposhis.sdcode=csubdept.sdcode
            join camphur on csubdept.amcode=camphur.amcode and csubdept.provcode=camphur.provcode
            join cprovince on csubdept.provcode=cprovince.provcode
            where pisposhis.id='#{id}' order by pisposhis.historder desc"
        rs = Pisposhis.find_by_sql(sql)
        totalCount = rs.count()
        
        return_data = {}
        return_data[:totalCount] = totalCount
        return_data[:Records]   = rs.collect{|u|{
            :id => u.id,
            :historder => u.historder,
            :forcedate => u.forcedate,
            :poscode => u.poscode,
            :excode => u.excode,
            :epcode => u.epcode,
            :mcode => u.mcode,
            :dcode => u.dcode,
            :deptcode => u.deptcode,
            :sdcode => u.sdcode,
            :seccode => u.seccode,
            :jobcode => u.jobcode,
            :updcode => u.updcode,
            :posid => u.posid,
            :c => u.c,
            :salary => u.salary,
            :refcmnd => u.refcmnd,
            :note => u.note,
            :fullsubdeptname => u.fullsubdeptname
          }
        }
        render :text => return_data.to_json,:layout => false
    end
    
    def save
        refcmnd = params[:refcmnd] #คำสั่ง
        updcode = params[:updcode] #การเคลื่อนไหว
        forcedate = params[:forcedate] #วันที่มีผลบังคับใช้
        poscode = params[:poscode] #ตำแหน่งสายงาน
        c = params[:c] #ระดับ
        salary = params[:salary] #เงินเดือน
        ptcode = params[:ptcode] #ว./วช./ชช.
        excode = params[:excode] #ตำแหน่งบริหาร
        epcode = params[:epcode] #ความเชี่ยวชาญ
        mincode = params[:mincode] #กระทรวง
        deptcode = params[:deptcode] #กรม
        dcode = params[:dcode] #กอง
        sdcode = params[:sdcode] #รหัสหน่วยงาน
        seccode = params[:seccode] #ฝ่าย /กลุ่มงาน
        jobcode = params[:jobcode] #งาน
        note = params[:note] #หมายเหตุ
        id = params[:id] #id ของบุคคล
        historder = params[:historder] #หมายเลขการเรียงลำดับของ pisposhis และจะใช้เป็น id หลักยึดเพื่อ update ด้วย
        posid = params[:posid] #เลขที่ตำแหน่ง
        chk1 = params[:chk1] #ปรับปรุงข้อมูลตำแหน่ง(จ.18)...ถือจ่ายปัจจุบัน จะคืนค่า true กับ false
        chk2 = params[:chk2] #ปรับปรุงข้อมูลปฏิบัติราชการปัจจุบัน จะคืนค่า true กับ false
        upddate = params[:upddate] #วันที่บันทึก เดี๋ยวให้ทาง postgres บันทึกเวลาเอง
        upduser = params[:upduser] #user ที่บันทึก
        
        if updcode == ""
            updcode = "null"
        end
        if poscode == ""
            poscode = "null"
        end
        if c == ""
            c = "null"
        end
        if salary == ""
            salary = "null"
        end
        if ptcode == ""
            ptcode = "null"
        end
        if excode == ""
            excode = "null"
        end
        if epcode == ""
            epcode = "null"
        end
        if mincode == ""
            mincode = "null"
        end
        if deptcode == ""
            deptcode = "null"
        end
        if dcode == ""
            dcode = "null"
        end
        if sdcode == ""
            sdcode = "null"
        end
        if seccode == ""
            seccode = "null"
        end
        if jobcode == ""
            jobcode = "null"
        end
        
        begin
            Pisposhis.transaction do
                
                #อย่าลืมปรับปรุงข้อมูล กรณีที่ติ๊กที่เช็คบ๊อกซ์ด้วยนะ
        
                #แก้ไขข้อมูลที่ประวัติคำสั่ง
                sql = "UPDATE pisposhis SET
                refcmnd='#{refcmnd}',
                forcedate='#{forcedate}',
                note='#{note}',
                updcode=#{updcode},
                poscode=#{poscode},
                c=#{c},
                salary=#{salary},
                ptcode=#{ptcode},
                excode=#{excode},
                epcode=#{epcode},
                mcode=#{mincode},
                deptcode=#{deptcode},
                dcode=#{dcode},
                sdcode=#{sdcode},
                seccode=#{seccode},
                jobcode=#{jobcode},
                upddate=now(),
                upduser='#{upduser}' 
                WHERE id='#{id}' AND historder=#{historder}"
                
                rs = Pisposhis.find_by_sql(sql)
                
                
                #หากติ๊กเช็คบ๊อกซ์ ปรับปรุงข้อมูลตำแหน่ง จ.18
                if chk1 == "true"
                    sql = "UPDATE pisj18 SET
                    poscode=#{poscode},
                    c=#{c},
                    salary=#{salary},
                    nowc=#{c},
                    nowsal=#{salary},
                    ptcode=#{ptcode},
                    excode=#{excode},
                    epcode=#{epcode},
                    mincode=#{mincode},
                    deptcode=#{deptcode},
                    dcode=#{dcode},
                    sdcode=#{sdcode},
                    seccode=#{seccode},
                    jobcode=#{jobcode},
                    upddate=now(),
                    upduser='#{upduser}' 
                    WHERE posid=#{posid}"
                    
                    rs = Pisj18.find_by_sql(sql)
                end
                
                #หากติ๊กเช็คบ๊อกซ์ ปรับปรุงข้อมูลปฏิบัติราชการปัจจุบัน
                if chk2 == "true"
                    sql = "UPDATE pispersonel SET
                    note='#{note}',
                    poscode=#{poscode},
                    c=#{c},
                    salary=#{salary},
                    ptcode=#{ptcode},
                    excode=#{excode},
                    epcode=#{epcode},
                    mincode=#{mincode},
                    deptcode=#{deptcode},
                    dcode=#{dcode},
                    sdcode=#{sdcode},
                    seccode=#{seccode},
                    jobcode=#{jobcode},
                    upddate=now(),
                    upduser='#{upduser}' 
                    WHERE id='#{id}'"
                    
                    rs = Pispersonel.find_by_sql(sql)
                end
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
