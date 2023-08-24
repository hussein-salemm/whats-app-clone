// ignore_for_file: public_member_api_docs, sort_constructors_first
class Call {
  final String callerId;
  final String callerName;
  final String callerPic; 
  final String receiverId;
  final String recieverName;
  final String recieverPic;
  final String callId;
  final bool hasDialled;
  Call({
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.receiverId,
    required this.recieverName,
    required this.recieverPic,
    required this.callId,
    required this.hasDialled,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'callerId': callerId,
      'callerName': callerName,
      'callerPic': callerPic,
      'receiverId': receiverId,
      'recieverName': recieverName,
      'recieverPic': recieverPic,
      'callId': callId,
      'hasDialled': hasDialled,
    };
  }

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      callerId: map['callerId'] as String,
      callerName: map['callerName'] as String,
      callerPic: map['callerPic'] as String,
      receiverId: map['receiverId'] as String,
      recieverName: map['recieverName'] as String,
      recieverPic: map['recieverPic'] as String,
      callId: map['callId'] as String,
      hasDialled: map['hasDialled'] as bool,
    );
  }
}
