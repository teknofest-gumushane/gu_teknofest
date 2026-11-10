import 'package:tf_data/tf_data.dart';

class ProjectsViewModel {
  Future<void> remove(String id) => projectRepository.softDeleteProject(id);
}
