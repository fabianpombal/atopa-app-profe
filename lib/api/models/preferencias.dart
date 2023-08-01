class PreferenciasFields {
  static final List<String> values = [
    id,
    user,
    sp,
    spv,
    np,
    data,
    ep,
    rp,
    ic,
    iap,
    ip,
    ipv,
    imp,
    ipp,
    pp,
    pap,
    os,
    oip
  ];

  static final String id = 'id';
  static final String user = 'user';
  static final String sp = 'sp';
  static final String spv = 'spv';
  static final String np = 'np';
  static final String data = 'data';
  static final String ep = 'ep';
  static final String rp = 'rp';
  static final String ic = 'ic';
  static final String iap = 'iap';
  static final String ip = 'ip';
  static final String ipv = 'ipv';
  static final String imp = 'imp';
  static final String ipp = 'ipp';
  static final String pp = 'pp';
  static final String pap = 'pap';
  static final String os = 'os';
  static final String oip = 'oip';
  
}

class Preferencias {
  final int? id;
  int user;
  int sp;
  int spv;
  int np;
  int data;
  int ep;
  int rp;
  int ic;
  int iap;
  int ip;
  int ipv;
  int imp;
  int ipp;
  int pp;
  int pap;
  int os;
  int oip;

  Preferencias(
      {this.id,
      required this.user,
      required this.sp,
      required this.spv,
      required this.np,
      required this.data,
      required this.ep,
      required this.rp,
      required this.ic,
      required this.iap,
      required this.ip,
      required this.ipv,
      required this.imp,
      required this.ipp,
      required this.pp,
      required this.pap,
      required this.os,
      required this.oip
      });

  factory Preferencias.fromJson(Map<String, Object?> json) => Preferencias(
      id: json[PreferenciasFields.id] as int?,
      user: json[PreferenciasFields.user] as int,
      sp: json[PreferenciasFields.sp] as int,
      spv: json[PreferenciasFields.spv] as int,
      np: json[PreferenciasFields.np] as int,
      data: json[PreferenciasFields.data] as int,
      ep: json[PreferenciasFields.ep] as int,
      rp: json[PreferenciasFields.rp] as int,
      ic: json[PreferenciasFields.ic] as int,
      iap: json[PreferenciasFields.iap] as int,
      ip: json[PreferenciasFields.ip] as int,
      ipv: json[PreferenciasFields.ipv] as int,
      imp: json[PreferenciasFields.imp] as int,
      ipp: json[PreferenciasFields.ipp] as int,
      pp: json[PreferenciasFields.pp] as int,
      pap: json[PreferenciasFields.pap] as int,
      os: json[PreferenciasFields.os] as int,
      oip: json[PreferenciasFields.oip] as int,

      );

  Map<String, Object?> toJson() => {
        PreferenciasFields.id: id,
        PreferenciasFields.user: user,
        PreferenciasFields.sp: sp,
        PreferenciasFields.spv: spv,
        PreferenciasFields.np: np,
        PreferenciasFields.data: data,
        PreferenciasFields.ep: ep,
        PreferenciasFields.rp: rp,
        PreferenciasFields.ic: ic,
        PreferenciasFields.iap: iap,
        PreferenciasFields.ip: ip,
        PreferenciasFields.ipv: ipv,
        PreferenciasFields.imp: imp,
        PreferenciasFields.ipp: ipp,
        PreferenciasFields.pp: pp,
        PreferenciasFields.pap: pap,
        PreferenciasFields.os: os,
        PreferenciasFields.oip: oip
      };

  Preferencias copy(
          {int? id,
          int? user,
          int? sp,
          int? spv,
          int? np,
          int? data,
          int? ep,
          int? rp,
          int? ic,
          int? iap,
          int? ip,
          int? ipv,
          int? imp,
          int? ipp,
          int? pp,
          int? pap,
          int? os,
          int? oip}) =>
      Preferencias(
          id: id ?? this.id,
          user: user ?? this.user,
          sp: sp ?? this.sp,
          spv: spv ?? this.spv,
          np: np ?? this.np,
          data: data ?? this.data,
          ep: ep ?? this.ep,
          rp: rp ?? this.rp,
          ic: ic ?? this.ic,
          iap: iap ?? this.iap,
          ip: ip ?? this.ip,
          ipv: ipv ?? this.ipv,
          imp: imp ?? this.imp,
          ipp: ipp ?? this.ipp,
          pp: pp ?? this.pp,
          pap: pap ?? this.pap,
          os: os ?? this.os,
          oip: oip ?? this.oip
          );
}
