module FirebaseHelper
  def self.push_log(request_id, message)
    base_uri = 'https://ffmpeglog.firebaseio.com/'
    firebase = Firebase::Client.new(base_uri, ENV['FIREBASE_SECRET_KEY'])
    response = firebase.push(request_id, message: message, priority: 1, created: Firebase::ServerValue::TIMESTAMP)
  end

  def self.clear_log(request_id)
    base_uri = 'https://ffmpeglog.firebaseio.com/'
    firebase = Firebase::Client.new(base_uri, ENV['FIREBASE_SECRET_KEY'])
    firebase.delete(request_id).success?
  end
end
