#
# Copyright @year@ @owner@
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# <@(#) $Id: cameliatk_tasks.rake,v 1.4 2007/10/10 12:26:48 jury Exp $>
#
# 改定履歴
# 2007/10/05 (岡村 淳司) [故障] migrateのバックアップでテーブルがない場合に停止する
# 2007/09/27 (岡村 淳司) [S41] 新規作成 移行ソリューション
#
# desc "Explaining what the task does"
# task :cameliatk do
#   # Task goes here
# end

def env_or_raise(var_name, human_name)
  if ENV[var_name].blank?
    raise "No #{var_name} value given. Set #{var_name}=#{human_name}"
  else
    return ENV[var_name]
  end  
end

def target_or_raise
  return env_or_raise('TARGET', 'TargetName')
end

def log task_name, msg
  File.open("#{migrate_base_pagh()}/migrate.log", "a") do |log|
    puts "#{DateTime.now.strftime('%Y/%m/%d %H:%M:%S')} [#{task_name}] #{msg}"
    log.puts "#{DateTime.now.strftime('%Y/%m/%d %H:%M:%S')} [#{task_name}] #{msg}"
  end
end

def migrate_base_pagh
  "migrate/#{target_or_raise}"
end

namespace :cameliatk do
  namespace :migrate do
    
    desc "migrate database and aplication by migrate/ directory. Use TARGET=TargetName"
    task :basic => :environment do
      task_name = "cameliatk:migrate:basic"

      log(task_name, "migrate for #{RAILS_ENV.to_sym.to_s}")
      if File.exists?("migrate/#{target_or_raise}/")
        log(task_name, "start #{target_or_raise}")
        Rake::Task["cameliatk:migrate:dump"].invoke
        
        Rake::Task["cameliatk:migrate:do_migrate"].invoke
        
        Rake::Task["cameliatk:migrate:load"].invoke
        log(task_name, "end #{target_or_raise}")
      else
        puts "Error! migrate/#{target_or_raise}/ was not found."
      end

    end
    
    task :dump => :environment do
      task_name = "cameliatk:migrate:dump"
      log(task_name, "start")

      bkup_base = "#{migrate_base_pagh()}/bkup"
      FileUtils.rm_r bkup_base if File.exists?(bkup_base)
      Dir.mkdir bkup_base unless File.exists?(bkup_base)
      
      pre_defined = Object.subclasses_of(ActiveRecord::Base)
      Dir["app/models/*.rb"].each {|i|
        eval File.basename(i, '.rb').classify
      }
      Dir["vendor/plugins/cameliatk_engine/app/models/*.rb"].each {|i|
        eval File.basename(i, '.rb').classify
      }
       (Object.subclasses_of(ActiveRecord::Base) - pre_defined).each{|klass|
        bkup_filename = "#{bkup_base}/#{klass.to_s}"
        log(task_name, "#{klass.to_s} dump to #{bkup_filename}")
        if klass.table_exists?
          klass.dump_to_file "#{bkup_filename}"
        else
          log(task_name, "#{klass.to_s} dump was skipped")
        end
      }
      log(task_name, "end")
    end
    
    task :load => :environment do
      task_name = "cameliatk:migrate:load"
      log(task_name ,"start")

      load_base = "#{migrate_base_pagh()}/load"
      if File.exists?(load_base)
        require 'active_record/fixtures'
        Dir["#{load_base}/*.yml"].each {|i|
          log(task_name, "load #{i}")
          Fixtures.create_fixtures(load_base, File.basename(i, '.*'))
        }

      else
        log(task_name, "no loadable data")
      end
      
      log(task_name, "end")
    end
    
    task :do_migrate => :environment do
      task_name = "cameliatk:migrate:do_migrate"
      log(task_name ,"start")
      
      Rake::Task["db:migrate"].invoke
      
      log(task_name, "end")
    end
    
  end

  namespace :db do

    task :dump_to => :environment do
      task_name = "cameliatk:migrate:dump"

      bkup_base = "#{migrate_base_pagh()}/bkup"
      FileUtils.rm_r bkup_base if File.exists?(bkup_base)
      Dir.mkdir bkup_base unless File.exists?(bkup_base)
      
      pre_defined = Object.subclasses_of(ActiveRecord::Base)
      Dir["app/models/*.rb"].each {|i|
        eval File.basename(i, '.rb').classify
      }
      Dir["vendor/plugins/cameliatk_engine/app/models/*.rb"].each {|i|
        eval File.basename(i, '.rb').classify
      }
       (Object.subclasses_of(ActiveRecord::Base) - pre_defined).each{|klass|
        bkup_filename = "#{bkup_base}/#{klass.to_s}"
        log(task_name, "#{klass.to_s} dump to #{bkup_filename}")
        if klass.table_exists?
          klass.dump_to_file "#{bkup_filename}"
        else
          log(task_name, "#{klass.to_s} dump was skipped")
        end
      }

    end

  end

end