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
# <@(#) $Id: DATABASE_README.txt,v 1.2 2007/08/29 13:21:41 jury Exp $>
#
# 改定履歴
# 2007/08/20 (岡村 淳司) "character set"指定追加
# 2007/08/07 (岡村 淳司) 新規作成
#
create database r3_development character set utf8;
create database r3_test character set utf8;
create database r3_production character set utf8;

GRANT ALL ON r3_development.* TO r3admin@localhost IDENTIFIED BY 'r3admin';
GRANT ALL ON r3_development.* TO r3admin@"%" IDENTIFIED BY 'r3admin';

GRANT ALL ON r3_test.* TO r3admin@localhost IDENTIFIED BY 'r3admin';
GRANT ALL ON r3_test.* TO r3admin@"%" IDENTIFIED BY 'r3admin';

GRANT ALL ON r3_production.* TO r3admin@localhost IDENTIFIED BY 'r3admin';
GRANT ALL ON r3_production.* TO r3admin@"%" IDENTIFIED BY 'r3admin';

