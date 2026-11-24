//  repo_config.dart 
//  Created by JeoJay127 
//
class RepoConfig {
  final String owner;
  final String repo;

  const RepoConfig({required this.owner, required this.repo});

  static const RepoConfig defaultConfig = RepoConfig(
    owner: 'bfykk',
    repo: 'LYEFI',
  );

  String get baseUrl => 'https://github.com/$owner/$repo';
  String get releasesUrl => '$baseUrl/releases';
}
