package butterfly.generator;

import massive.munit.Assert;
import butterfly.generator.HtmlGenerator;
import butterfly.core.Post;
import test.helpers.Factory;

class HtmlGeneratorTest
{
	@Test
  // In Butterfly 0.3, we stopped auto-inserting the title in the post in a <h2>
  // tag. Butterfly now generates the titleif/where the layout has a <butterfly-title />
	// tag (it doesn't generate any additional HTML).
	public function generatePostHtmlDoesntAutomaticallyInsertTitle()
	{
    var gen = Factory.createHtmlGenerator();
    var post = new Post();
		post.title = "Running MUnit with Haxelib";

    var actual = gen.generatePostHtml(post, Factory.createButterflyConfig());
    Assert.areEqual(-1, actual.indexOf(post.title));
	}

	@Test
	public function generatePostHtmlReplacesButterflyTitleTagWithPostTitle()
	{
		var layout = "<butterfly-pages /><h2><butterfly-title /></h2>\n<butterfly-content /><butterfly-tags />";
		var gen = Factory.createHtmlGenerator(layout);
    var post = new Post();
		post.title = "Regex Replacement in Haxe";

    var actual = gen.generatePostHtml(post, Factory.createButterflyConfig());
    Assert.isTrue(actual.indexOf('<h2>${post.title}</h2>') > -1);
	}

	@Test
	public function generateIntraSiteLinksReplacesPageAndPostTitlesWithLinks()
	{
		var post = new Post();
		post.title = "Chocolate Truffles: Delicious or Unhealthy?";
		post.url = "http://fake.com/chocolate-truffles-unhealthy-eh";

		var page = new Page();
		page.title = "About Le Chocolatier";
		page.url = "http://fake.com/about";

		var content = 'Do not ask [[${page.title}]]; just read this: are ${post.title}';

		var generator = new HtmlGenerator("<butterfly-pages /><butterfly-content /><butterfly-tags />",
			[post], [page]);

		var actual = generator.generateIntraSiteLinks(content);
		Assert.isTrue(actual.indexOf(post.url) > -1);
		Assert.isTrue(actual.indexOf(page.url) > -1);
	}
}
