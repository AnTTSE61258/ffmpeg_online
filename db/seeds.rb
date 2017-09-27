# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Format.create(name: 'mpeg', description: 'MPEG-1 Systems / MPEG program stream')
Format.create(name: 'mp4', description: 'MP4 (MPEG-4 Part 14)')
Format.create(name: 'h264', description: 'raw H.264 video')
Format.create(name: 'avi', description: 'AVI (Audio Video Interleaved)')
Format.create(name: 'avi', description: 'AVI (Audio Video Interleaved)')
Format.create(name: 'asf', description: 'ASF (Advanced / Active Streaming Format)')
Format.create(name: 'mov', description: 'QuickTime / MOV')
Format.create(name: 'flv', description: 'FLV (Flash Video)')