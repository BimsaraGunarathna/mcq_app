import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:async/async.dart';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';

//Models
import '../models/s3_image_upload_policy.dart';

//Credentials
import '../credentials//aws_user_pool_credential.dart';


//uplaod an image to S3
  Future<void> uploadImageToS3(String filePath) async {
    //PermissionStatus permissionResult =
        //await SimplePermissions.requestPermission(
            //Permission.WriteExternalStorage);
    //if (permissionResult == PermissionStatus.authorized) {
      //File file = await FilePicker.getFile();
      //print(file);
      final _userPool = CognitoUserPool(awsUserPoolId, awsClientId);

      final _cognitoUser =
          CognitoUser('bimsara.gunarathna@gmail.com', _userPool);
      final authDetails = AuthenticationDetails(
          username: 'bimsara.gunarathna@gmail.com', password: 'test1234');

      CognitoUserSession _session;
      try {
        _session = await _cognitoUser.authenticateUser(authDetails);
      } catch (e) {
        print(e);
      }

      final _credentials = CognitoCredentials(identityPoolId, _userPool);
      await _credentials.getAwsCredentials(_session.getIdToken().getJwtToken());

      const _region = 'ap-south-1';
      const _s3Endpoint = 'https://gn-img.s3-ap-south-1.amazonaws.com';

      //var file = File(path.join('/storage/emulated/0/New', 'second.jpg'));
      //File file = await FilePicker.getFile(type: FileType.IMAGE);
      filePath = await FilePicker.getFilePath(type: FileType.image);
      File file = File(filePath);
      print('CHOOSEN FILE NAME: $file');

      String fileName = filePath.split("/").last;
      print(fileName);
      //print(fileString.substring(6));

      //String filePathString =  await file.readAsString();
      //print('FILE STRING: ' + filePathString);

      //depricated typed is removed.
      //DelegatingStream.typed(file.openRead())
      final stream = http.ByteStream(DelegatingStream(file.openRead()));
      final length = await file.length();

      final uri = Uri.parse(_s3Endpoint);
      final req = http.MultipartRequest("POST", uri);
      final multipartFile = http.MultipartFile('file', stream, length,
          filename: path.basename(file.path));

      final policy = Policy.fromS3PresignedPost(
        fileName,
        'gn-img',
        15,
        _credentials.accessKeyId,
        length,
        _credentials.sessionToken,
        region: _region,
      );
      final key = SigV4.calculateSigningKey(
          _credentials.secretAccessKey, policy.datetime, _region, 's3');
      final signature = SigV4.calculateSignature(key, policy.encode());

      req.files.add(multipartFile);
      req.fields['key'] = policy.key;
      req.fields['acl'] = 'public-read';
      req.fields['X-Amz-Credential'] = policy.credential;
      req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
      req.fields['X-Amz-Date'] = policy.datetime;
      req.fields['Policy'] = policy.encode();
      req.fields['X-Amz-Signature'] = signature;
      req.fields['x-amz-security-token'] = _credentials.sessionToken;

      try {
        final res = await req.send();
        await for (var value in res.stream.transform(utf8.decoder)) {
          print(value);
        }
      } catch (e) {
        print(e.toString());
      }
    //}
  }