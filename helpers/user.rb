module User
  PRIVATE_FIELDS = [:public_id]

  def self.build_profile_picture_url(path)
    pic_url = path.split('/')
    pic_url.shift
    pic_url.join('/')
  end

  def self.save_profile_picture(path, file)
    File.open(path, 'w') do |f|
      f.write(file.read)
    end
  end
end