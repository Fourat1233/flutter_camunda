class Process_def {
  String? id;
  String? key;
  String? category;
  Null? description;
  String? name;
  int? version;
  String? resource;
  String? deploymentId;
  Null? diagram;
  bool? suspended;
  Null? tenantId;
  String? versionTag;
  int? historyTimeToLive;
  bool? startableInTasklist;

  Process_def(
      {this.id,
      this.key,
      this.category,
      this.description,
      this.name,
      this.version,
      this.resource,
      this.deploymentId,
      this.diagram,
      this.suspended,
      this.tenantId,
      this.versionTag,
      this.historyTimeToLive,
      this.startableInTasklist});

  Process_def.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    category = json['category'];
    description = json['description'];
    name = json['name'];
    version = json['version'];
    resource = json['resource'];
    deploymentId = json['deploymentId'];
    diagram = json['diagram'];
    suspended = json['suspended'];
    tenantId = json['tenantId'];
    versionTag = json['versionTag'];
    historyTimeToLive = json['historyTimeToLive'];
    startableInTasklist = json['startableInTasklist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['key'] = this.key;
    data['category'] = this.category;
    data['description'] = this.description;
    data['name'] = this.name;
    data['version'] = this.version;
    data['resource'] = this.resource;
    data['deploymentId'] = this.deploymentId;
    data['diagram'] = this.diagram;
    data['suspended'] = this.suspended;
    data['tenantId'] = this.tenantId;
    data['versionTag'] = this.versionTag;
    data['historyTimeToLive'] = this.historyTimeToLive;
    data['startableInTasklist'] = this.startableInTasklist;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return name!;
  }
}
