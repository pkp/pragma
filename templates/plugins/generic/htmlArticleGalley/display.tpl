{**
* plugins/generic/htmlArticleGalley/display.tpl
*
* Copyright (c) 2014-2018 Simon Fraser University
* Copyright (c) 2003-2018 John Willinsky
* Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
*
* Embedded viewing of a HTML galley.
*}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{capture assign="pageTitleTranslated"}{translate key="article.pageTitle" title=$article->getLocalizedTitle()}{/capture}
{include file="frontend/components/header.tpl"}

<body class="pkp_page_{$requestedPage|escape} pkp_op_{$requestedOp|escape}">

	<main class="container galley">
		<div class="row">
			<header class="offset-md-2 col-md-8 galley__header">
				<p>
					<a href="{url page="article" op="view" path=$article->getBestArticleId()}" class="btn btn-secondary">
						&larr; {translate key="article.return"}
					</a>
				</p>

				<h1>{$article->getLocalizedTitle()}</h1>
			</header>

			<div id="htmlContainer" class="offset-md-2 col-md-8 galley__content">
				<iframe id="htmlGalleyFrame" name="htmlFrame" src="{url page="article" op="download" path=$article->getBestArticleId()|to_array:$galley->getBestGalleyId() inline=true}" allowfullscreen webkitallowfullscreen></iframe>
			</div>
		</div>
	</main>

	{call_hook name="Templates::Common::Footer::PageFooter"}

	{include file="frontend/components/footer.tpl"}

	{* Default style if CSS isn't attached to the HTML Galley *}
	{if $boolEmbeddedCss === false}
	<script type="text/javascript">{literal}
	window.onload = function() {
		var iframe = document.getElementById('htmlGalleyFrame');
		var insideFrame = iframe.contentDocument || iframe.contentWindow.document;
		var headNode = insideFrame.getElementsByTagName('head')[0];

		// Loading CSS stylesheet

		var linkElement = document.createElement('link');
		linkElement.type = 'text/css';
		linkElement.rel = 'stylesheet';
		linkElement.href = "{/literal}{$themePath|escape:"javascript"}{literal}/templates/plugins/generic/htmlArticleGalley/css/default.css";
		headNode.appendChild(linkElement);

	};

	{/literal}</script>

	{/if}
</body>
</html>
