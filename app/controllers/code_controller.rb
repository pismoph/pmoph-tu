# coding: utf-8
class CodeController < ApplicationController
    skip_before_filter :verify_authenticity_token

    #---------------------------------------------------------------------------
    
    def cprovince
        sql = "SELECT provcode, provname FROM cprovince ORDER BY provname"
        rs = Cjob.find_by_sql(sql)
        return_data = Hash.new()
        return_data[:Records]   = rs.collect{|u| {   
          :provcode => u.provcode,
          :provname => u.provname
        } }
        render :text => return_data.to_json, :layout => false
    end
    
    def cupdate
        limit = params[:limit].to_i
        start = params[:start].to_i
        search = ""
        if params[:query].to_s != ""      
            search = "and (updcode::varchar = '#{params[:query]}'"
            search += " or updname::varchar like '%#{params[:query]}%' )";
        end
        if params[:updcode].to_s != ""
            search += " and updcode = '#{params[:updcode]}' "
        end
        records = Cupdate.where("use_status = '1' #{search}").paginate :per_page => limit,:page => ((start / limit) + 1)
        return_data = Hash.new()
        return_data[:success] = true
        return_data[:totalcount] = Cupdate.where("use_status = '1' #{search}").count()
        return_data[:records] = records.collect{|u|{   
            :updcode => u.updcode,
            :updname => "#{u.updname}(#{u.updcode})".strip
        }}
        render :text => return_data.to_json, :layout => false  
    end
    
    def cposition
        limit = params[:limit].to_i
        start = params[:start].to_i
        search = ""
        if params[:query].to_s != ""      
            search = "and (poscode::varchar = '#{params[:query]}'"
            search += " or posname::varchar like '%#{params[:query]}%' )";
        end
        if params[:poscode].to_s != ""
            search += " and poscode = '#{params[:poscode]}' "
        end
        records = Cposition.where("use_status = '1' #{search}").paginate :per_page => limit,:page => ((start / limit) + 1)
        return_data = Hash.new()
        return_data[:success] = true
        return_data[:totalcount] = Cposition.where("use_status = '1' #{search}").count()
        return_data[:records] = records.collect{|u|{   
            :poscode => u.poscode,
            :posname => "#{u.posname}(#{u.poscode})".strip
        }}
        render :text => return_data.to_json, :layout => false  
    end
    
    def cgrouplevel
        limit = params[:limit].to_i
        start = params[:start].to_i
        search = ""
        if params[:query].to_s != ""      
            search = "and (ccode::varchar = '#{params[:query]}'"
            search += " or cname::varchar like '%#{params[:query]}%' )";
        end
        if params[:ccode].to_s != ""
            search += " and ccode = '#{params[:ccode]}' "
        end
        records = Cgrouplevel.where("use_status = '1' #{search}").paginate :per_page => limit,:page => ((start / limit) + 1)
        return_data = Hash.new()
        return_data[:success] = true
        return_data[:totalcount] = Cgrouplevel.where("use_status = '1' #{search}").count()
        return_data[:records] = records.collect{|u|{   
            :ccode => u.ccode,
            :cname => "#{u.cname}(#{u.ccode})".strip
        }}
        render :text => return_data.to_json, :layout => false  
    end
    
    def cexecutive
        limit = params[:limit].to_i
        start = params[:start].to_i
        search = ""
        if params[:query].to_s != ""      
            search = "and (excode::varchar = '#{params[:query]}'"
            search += " or exname::varchar like '%#{params[:query]}%' )";
        end
        if params[:excode].to_s != ""
            search += " and excode = '#{params[:excode]}' "
        end
        records = Cexecutive.where("use_status = '1' #{search}").order("shortpre").order("exname").paginate :per_page => limit,:page => ((start / limit) + 1)
        return_data = Hash.new()
        return_data[:success] = true
        return_data[:totalcount] = Cexecutive.where("use_status = '1' #{search}").count()
        return_data[:records] = records.collect{|u|{   
            :excode => u.excode,
            :exname => "#{u.shortpre}#{u.exname}(#{u.excode})".strip
        }}
        render :text => return_data.to_json, :layout => false  
    end
    
    def cexpert
        limit = params[:limit].to_i
        start = params[:start].to_i
        search = ""
        if params[:query].to_s != ""      
            search = "and (epcode::varchar = '#{params[:query]}'"
            search += " or expert::varchar like '%#{params[:query]}%' )";
        end
        if params[:epcode].to_s != ""
            search += " and epcode = '#{params[:epcode]}' "
        end
        records = Cexpert.where("use_status = '1' #{search}").order("expert").paginate :per_page => limit,:page => ((start / limit) + 1)
        return_data = Hash.new()
        return_data[:success] = true
        return_data[:totalcount] = Cexpert.where("use_status = '1' #{search}").count()
        return_data[:records] = records.collect{|u|{   
            :epcode => u.epcode,
            :expert => "#{u.prename}#{u.expert}(#{u.epcode})".strip
        }}
        render :text => return_data.to_json, :layout => false  
    end
    
    def cpostype
        limit = params[:limit].to_i
        start = params[:start].to_i
        search = ""
        if params[:query].to_s != ""      
            search = "and (ptcode::varchar = '#{params[:query]}'"
            search += " or ptname::varchar like '%#{params[:query]}%' )";
        end
        if params[:ptcode].to_s != ""
            search += " and ptcode = '#{params[:ptcode]}' "
        end
        records = Cpostype.where("use_status = '1' #{search}").paginate :per_page => limit,:page => ((start / limit) + 1)
        return_data = Hash.new()
        return_data[:success] = true
        return_data[:totalcount] = Cpostype.where("use_status = '1' #{search}").count()
        return_data[:records] = records.collect{|u|{   
            :ptcode => u.ptcode,
            :ptname => "#{u.ptname}(#{u.ptcode})".strip
        }}
        render :text => return_data.to_json, :layout => false  
    end
    
    def cministry
        limit = params[:limit].to_i
        start = params[:start].to_i
        search = ""
        if params[:query].to_s != ""      
            search = "and (mcode::varchar = '#{params[:query]}'"
            search += " or minname::varchar like '%#{params[:query]}%' )";
        end
        if params[:mcode].to_s != ""
            search += " and mcode = '#{params[:mcode]}' "
        end
        records = Cministry.where("use_status = '1' #{search}").order("minname").paginate :per_page => limit,:page => ((start / limit) + 1)
        return_data = Hash.new()
        return_data[:success] = true
        return_data[:totalcount] = Cministry.where("use_status = '1' #{search}").count()
        return_data[:records] = records.collect{|u|{   
            :mcode => u.mcode,
            :minname => "#{u.minname}(#{u.mcode})".strip
        }}
        render :text => return_data.to_json, :layout => false  
    end
    
    def cdept
        limit = params[:limit].to_i
        start = params[:start].to_i
        search = ""
        if params[:query].to_s != ""      
            search = "and (deptcode::varchar = '#{params[:query]}'"
            search += " or deptname::varchar like '%#{params[:query]}%' )";
        end
        if params[:deptcode].to_s != ""
            search += " and deptcode = '#{params[:deptcode]}' "
        end
        records = Cdept.where("use_status = '1' #{search}").order("deptname").paginate :per_page => limit,:page => ((start / limit) + 1)
        return_data = Hash.new()
        return_data[:success] = true
        return_data[:totalcount] = Cdept.where("use_status = '1' #{search}").count()
        return_data[:records] = records.collect{|u|{   
            :deptcode => u.deptcode,
            :deptname => "#{u.deptname}(#{u.deptcode})".strip
        }}
        render :text => return_data.to_json, :layout => false  
    end
    
    def cdivision
        limit = params[:limit].to_i
        start = params[:start].to_i
        search = ""
        if params[:query].to_s != ""      
            search = "and (dcode::varchar = '#{params[:query]}'"
            search += " or division::varchar like '%#{params[:query]}%' )";
        end
        if params[:dcode].to_s != ""
            search += " and dcode = '#{params[:dcode]}' "
        end
        records = Cdivision.where("use_status = '1' #{search}").order("division").paginate :per_page => limit,:page => ((start / limit) + 1)
        return_data = Hash.new()
        return_data[:success] = true
        return_data[:totalcount] = Cdivision.where("use_status = '1' #{search}").count()
        return_data[:records] = records.collect{|u|{   
            :dcode => u.dcode,
            :division => "#{u.division}(#{u.dcode})".strip
        }}
        render :text => return_data.to_json, :layout => false  
    end

    def csubsdcode
        limit = params[:limit].to_i
        start = params[:start].to_i
        search = ""
        if params[:query].to_s != ""      
            search = "and (subsdcode::varchar = '#{params[:query]}'"
            search += " or subsdname::varchar like '%#{params[:query]}%' )";
        end
        if params[:subsdcode].to_s != ""
            search += " and subsdcode = '#{params[:subsdcode]}' "
        end
        records = Csubsdcode.where("#{search}").paginate :per_page => limit,:page => ((start / limit) + 1)
        return_data = Hash.new()
        return_data[:success] = true
        return_data[:totalcount] = Csubsdcode.where("use_status = '1' #{search}").count()
        return_data[:records] = records.collect{|u|{   
            :subsdcode => u.subsdcode,
            :subsdname => "#{u.subsdname}(#{u.subsdcode})".strip
        }}
        render :text => return_data.to_json, :layout => false  
    end

    def csection
        limit = params[:limit].to_i
        start = params[:start].to_i
        search = ""
        if params[:query].to_s != ""      
            search = "and (seccode::varchar = '#{params[:query]}'"
            search += " or secname::varchar like '%#{params[:query]}%' )";
        end
        if params[:seccode].to_s != ""
            search += " and seccode = '#{params[:seccode]}' "
        end
        records = Csection.where("use_status = '1' #{search}").order("secname").paginate :per_page => limit,:page => ((start / limit) + 1)
        return_data = Hash.new()
        return_data[:success] = true
        return_data[:totalcount] = Csection.where("use_status = '1' #{search}").count()
        return_data[:records] = records.collect{|u|{   
            :seccode => u.seccode,
            :secname => "#{u.secname}(#{u.shortname})(#{u.seccode})".strip
        }}
        render :text => return_data.to_json, :layout => false  
    end
    
    def cjob
        limit = params[:limit].to_i
        start = params[:start].to_i
        search = ""
        if params[:query].to_s != ""      
            search = "and (jobcode::varchar = '#{params[:query]}'"
            search += " or jobname::varchar like '%#{params[:query]}%' )";
        end
        if params[:jobcode].to_s != ""
            search += " and jobcode = '#{params[:jobcode]}' "
        end
        records = Cjob.where("use_status = '1' #{search}").order("jobname").paginate :per_page => limit,:page => ((start / limit) + 1)
        return_data = Hash.new()
        return_data[:success] = true
        return_data[:totalcount] = Cjob.where("use_status = '1' #{search}").count()
        return_data[:records] = records.collect{|u|{   
            :jobcode => u.jobcode,
            :jobname => "#{u.jobname}(#{u.jobcode})".strip
        }}
        render :text => return_data.to_json, :layout => false  
    end
    
    def cprefix
        records = Cprefix.where("1=1")
        return_data = Hash.new()
        return_data[:Records]   = records.collect{|u| {   
          :pcode => u.pcode,
          :prefix => u.prefix
        } }
        render :text => return_data.to_json, :layout => false
    end
    
    def cqualify
        limit = params[:limit].to_i
        start = params[:start].to_i
        search = ""
        if params[:query].to_s != ""      
            search = "and (qcode::varchar = '#{params[:query]}'"
            search += " or qualify::varchar like '%#{params[:query]}%' )";
        end
        if params[:qcode].to_s != ""
            search += " and qcode = '#{params[:qcode]}' "
        end
        records = Cqualify.where("use_status = '1' #{search}").paginate :per_page => limit,:page => ((start / limit) + 1)
        return_data = Hash.new()
        return_data[:success] = true
        return_data[:totalcount] = Cqualify.where("use_status = '1' #{search}").count()
        return_data[:records] = records.collect{|u|{   
            :qcode => u.qcode,
            :qualify => "#{u.qualify}(#{u.qcode})".strip
        }}
        render :text => return_data.to_json, :layout => false  
    end
    
    def cmajor
        limit = params[:limit].to_i
        start = params[:start].to_i
        search = ""
        if params[:query].to_s != ""      
            search = "and (macode::varchar = '#{params[:query]}'"
            search += " or major::varchar like '%#{params[:query]}%' )";
        end
        if params[:macode].to_s != ""
            search += " and macode = '#{params[:macode]}' "
        end
        records = Cmajor.where("use_status = '1' #{search}").order("major").paginate :per_page => limit,:page => ((start / limit) + 1)
        return_data = Hash.new()
        return_data[:success] = true
        return_data[:totalcount] = Cmajor.where("use_status = '1' #{search}").count()
        return_data[:records] = records.collect{|u|{   
            :macode => u.macode,
            :major => "#{u.major}(#{u.macode})".strip
        }}
        render :text => return_data.to_json, :layout => false  
    end
    
    def ctrade
        records = Ctrade.where("1=1")
        return_data = Hash.new()
        return_data[:Records]   = records.collect{|u| {   
          :codetrade => u.codetrade,
          :trade => u.trade
        } }
        render :text => return_data.to_json, :layout => false
    end
    
    def cj18status
        records = Cj18status.where("1=1")
        return_data = Hash.new()
        return_data[:Records]   = records.collect{|u| {   
          :j18code => u.j18code,
          :j18status => u.j18status
        } }
        render :text => return_data.to_json, :layout => false
    end
end
