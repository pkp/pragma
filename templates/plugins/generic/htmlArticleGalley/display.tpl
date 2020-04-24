{**
* plugins/generic/htmlArticleGalley/display.tpl
*
* Copyright (c) 2014-2020 Simon Fraser University
* Copyright (c) 2003-2020 John Willinsky
* Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
*
* Embedded viewing of a HTML galley.
*}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{capture assign="pageTitleTranslated"}{translate key="article.pageTitle" title=$article->getLocalizedTitle()|escape}{/capture}
{include file="frontend/components/header.tpl"}

<body class="pkp_page_{$requestedPage|escape} pkp_op_{$requestedOp|escape}">

<main class="container galley">

    {capture assign="articleUrl"}{url page="article" op="view" path=$article->getBestId()}{/capture}

	<div class="row">
		<header class="offset-md-2 col-md-8 galley__header">
			<p>
				<a href="{$articleUrl}" class="btn btn-secondary">
					&larr; {translate key="article.return"}
				</a>
			</p>

			<h1>{$article->getLocalizedTitle()|escape}</h1>

            {if !$isLatestPublication}
				<div class="galley_view_notice">
					<div class="galley_view_notice_message" role="alert">
                        {translate key="submission.outdatedVersion" datePublished=$galleyPublication->getData('datePublished')|date_format:$dateFormatLong urlRecentVersion=$articleUrl}
					</div>
				</div>
                {capture assign="htmlUrl"}
                    {url page="article" op="download" path=$article->getBestId()|to_array:'version':$galleyPublication->getId():$galley->getBestGalleyId() inline=true}
                {/capture}
            {else}
                {capture assign="htmlUrl"}
                    {url page="article" op="download" path=$article->getBestId()|to_array:$galley->getBestGalleyId() inline=true}
                {/capture}
            {/if}
		</header>

		<div id="htmlContainer" class="offset-md-2 col-md-8 galley__content"
		     style="overflow:visible;-webkit-overflow-scrolling:touch">
			<iframe id="htmlGalleyFrame" name="htmlFrame" src="{$htmlUrl}" allowfullscreen
			        webkitallowfullscreen></iframe>
		</div>
	</div>
</main>

{call_hook name="Templates::Common::Footer::PageFooter"}

{include file="frontend/components/footer.tpl"}
</body>
</html>
