module FirebaseHelper
  def self.push_log(request_id, message, from_time)
    base_uri = 'https://ffmpeglog.firebaseio.com/'
    firebase = Firebase::Client.new(base_uri, ['FIREBASE_SECRET_KEY'])
    response = firebase.push(request_id, { :message => message, :priority => 1, :created => Firebase::ServerValue::TIMESTAMP})

  end
end