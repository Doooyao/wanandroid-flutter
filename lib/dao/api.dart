class Api {
  static const String host = 'https://www.wanandroid.com/';

  //首页最新文章
  static homeArticleList(page) => "${host}article/list/$page/json";

  //首页置顶文章
  static homeTopArticleList() => "${host}article/top/json";

  //首页最新项目
  static homeProjectList(page) => "${host}article/listproject/$page/json";

  //首页banner
  static homeBanner() => "${host}banner/json";

  //获取体系标签
  static getTagSystem() => "${host}tree/json";

  //搜索
  static doSearch(page, query) => "${host}article/query/$page/json?k=$query";

  //当前搜索热词
  static getSearchHotQuery() => "${host}hotkey/json";

  //获取某个二级体系下的文章
  static articlesOfSystem(page, systemId) =>
      "${host}article/list/$page/json?cid=$systemId";

  //登录
  static signIn(String username, String password) =>
      "${host}user/login?username=$username&password=$password";

  //注册
  static signUp(String username, String password, String repassword) =>
      "${host}user/register?username=$username&password=$password&repassword=$repassword";

  //退出
  static signOut() => "${host}user/logout/json";

  // 获取收藏的文章列表
  static getCollectArticle(int page) => "${host}lg/collect/list/$page/json";

  // 收藏站内文章 POST
  static doCollectInnerArticle(int id) => "${host}lg/collect/$id/json";

  // 收藏站外文章 POST
  static doCollectOuterArticle(String title, String author, String link) =>
      "${host}lg/collect/add/json?title=$title&author=$author&link=$link";

  // 通过站内文章id取消收藏 POST
  static unCollectWithArticleId(int articleId) => "${host}lg/uncollect_originId/$articleId/json";

  // 通过收藏id取消收藏 POST
  static unCollectWithCollectId(int collectId) => "${host}lg/uncollect/$collectId/json";

}
