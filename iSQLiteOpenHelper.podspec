Pod::Spec.new do |s|

  s.name = "iSQLiteOpenHelper"
  s.version = "0.0.1"
  s.summary = "iOS iSQLiteOpenHelper Just like Android SQLiteOpenHelper"
  s.homepage = "https://github.com/since2006/iSQLiteOpenHelper"
  s.license = "MIT"
  s.author = "since2006"
  s.source       = { :git => "https://github.com/since2006/iSQLiteOpenHelper.git", :tag => "#{s.version}" }
  s.source_files  = "iSQLiteOpenHelper", "iSQLiteOpenHelper/**/*.{h,m}"
  s.requires_arc = true
  s.dependency "FMDB"

end
