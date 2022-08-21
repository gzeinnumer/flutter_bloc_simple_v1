class ExampleRepo{
  Future<bool> validate(String editText) async{
    await Future.delayed(const Duration(seconds: 1));
    return editText.contains("a");
  }
}