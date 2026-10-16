{**
* plugins/generic/htmlArticleGalley/templates/display.tpl
*
* Copyright (c) 2014-2026 Simon Fraser University
* Copyright (c) 2003-2026 John Willinsky
* Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
*
* Embedded viewing of a HTML galley.
*}
{capture assign="pageTitleTranslated"}{translate key="article.pageTitle" title=$article->getCurrentPublication()->getLocalizedFullTitle(null, 'html')|strip_unsafe_html}{/capture}
{include file="frontend/components/header.tpl"}

<main class="container galley" id="main">

    {capture assign="articleUrl"}{url page="article" op="view" path=$article->getBestId()}{/capture}

	<div class="row">
		<header class="offset-md-2 col-md-8 galley__header">
			<p>
				<a href="{$articleUrl}" class="btn btn-secondary">
					&larr; {translate key="article.return"}
				</a>
			</p>

			<h1>{$article->getCurrentPublication()->getLocalizedTitle(null, 'html')|strip_unsafe_html}</h1>

            {if !$isLatestPublication}
				<div class="galley_view_notice">
					<div class="galley_view_notice_message" role="alert">
                        {translate key="submission.outdatedVersion" datePublished=$galleyPublication->getData('datePublished')|date_format:$dateFormatLong urlRecentVersion=$articleUrl}
					</div>
				</div>
                {capture assign="htmlUrl"}
                    {url page="article" op="download" path=$article->getBestId()|to_array:'version':$galleyPublication->getId():$galley->getBestGalleyId():$submissionFile->getId() inline=true}
                {/capture}
            {else}
                {capture assign="htmlUrl"}
                    {url page="article" op="download" path=$article->getBestId()|to_array:$galley->getBestGalleyId():$submissionFile->getId() inline=true}
                {/capture}
            {/if}
		</header>

		<div id="htmlContainer" class="offset-md-2 col-md-8 galley__content"
		     style="overflow:visible;-webkit-overflow-scrolling:touch">
			<iframe id="htmlGalleyFrame" name="htmlFrame" src="{$htmlUrl}" title="{translate key="submission.representationOfTitle" representation=$galley->getLabel()|escape title=$galleyPublication->getLocalizedFullTitle(null)|escape}" allowfullscreen
			        webkitallowfullscreen></iframe>
		</div>
	</div>
</main>

{include file="frontend/components/footer.tpl"}
