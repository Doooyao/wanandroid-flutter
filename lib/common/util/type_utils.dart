class JustKeyType<RealType> extends Type{

  String key;

  Type get realType => RealType;

  static final Map<Type,Map<String,JustKeyType>> map = Map();

  JustKeyType(this.key);

  static JustKeyType get<RealType>(String key){
    if(!map.containsKey(RealType))
      map[RealType] = Map();
    if(!map[RealType].containsKey(key))
      map[RealType][key] = JustKeyType<RealType>(key);
    return map[RealType][key];
  }
}
