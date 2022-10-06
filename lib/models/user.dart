class User {
  String? username;
  String? nama;
  String? tanggalLahir;
  String? umur;

  User({name, email, phone, pict});

  User.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        nama = json['nama'],
        tanggalLahir = json['tgl_lahir'].toString(),
        umur = json['umur'].toString();
}
