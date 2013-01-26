# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 初期管理アカウント
# アカウントが存在しない場合にのみ、管理者アカウントを生成する。
if User.find( :all ).count <= 0
  admin_user = User.create_user(
    'admin', 'admin!', User::TYPE_ADMIN, '', 'Administrator', ''
  )
end

