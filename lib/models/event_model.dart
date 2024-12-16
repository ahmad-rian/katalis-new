class Event {
  final int id;
  final String namaEvent;
  final String deskripsi;
  final String jenis;
  final String? gambar;
  final String? imageUrl;
  final String createdAt;
  final String updatedAt;

  Event({
    required this.id,
    required this.namaEvent,
    required this.deskripsi,
    required this.jenis,
    this.gambar,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      namaEvent: json['nama_event'],
      deskripsi: json['deskripsi'],
      jenis: json['jenis'],
      gambar: json['gambar'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
