import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:permission_handler/permission_handler.dart';
class MediaService{
  MediaService(){}
  
  Future<PlatformFile?> pickImageFromLibrary()async {
    try{
      FilePickerResult? _result = await FilePicker.platform.pickFiles(
          type: FileType.image);
      if (_result != null) {
        print(_result.files[0]);
        return _result.files[0];
      }
    }catch(e){
      print(' unable to select file $e');
    }
    return null;
    
  }
  
}