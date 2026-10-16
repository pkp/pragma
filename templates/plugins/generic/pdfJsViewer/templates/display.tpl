{**
* plugins/generic/pdfJsViewer/templates/display.tpl
*
* Copyright (c) 2014-2026 Simon Fraser University
* Copyright (c) 2003-2026 John Willinsky
* Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
*
* Embedded viewing of a PDF galley.
*}
{capture assign="pageTitleTranslated"}{if $isTitleHtml}{translate key="article.pageTitle" title=$title|strip_tags|escape}{else}{translate key="article.pageTitle" title=$title|escape}{/if}{/capture}
{include file="frontend/components/header.tpl"}

	<main class="container galley" id="main">
		<div class="row">
			<header class="offset-lg-1 col-lg-10 galley__header">
				<p>
					<a href="{$parentUrl}" class="btn btn-secondary">
						&larr;
						{if $issue}
						{translate key="issue.return"}
						{else}
						{translate key="article.return"}
						{/if}
					</a>

					<a href="{$pdfUrl}" class="btn btn-primary float-right" download>
						{translate key="common.download"}
						<span class="visually-hidden">
							{translate key="common.downloadPdf"}
						</span>
					</a>
				</p>
				<h1>
					{if $isTitleHtml}
						{$title|strip_unsafe_html}
					{else}
						{$title|escape}
					{/if}
				</h1>

				{if !$isLatestPublication}
					<div role="alert">
						{translate key="submission.outdatedVersion" datePublished=$galleyPublication->getData('datePublished')|date_format:$dateFormatLong urlRecentVersion=$parentUrl}
					</div>
				{/if}
			</header>

			<script type="text/javascript">
				// Creating iframe's src in JS instead of Smarty so that EZProxy-using sites can find our domain in $pdfUrl and do their rewrites on it.
				document.addEventListener("DOMContentLoaded", function() {ldelim}
					var urlBase = "{$pluginUrl}/pdf.js/web/viewer.html?file=";
					var pdfUrl = {$pdfUrl|json_encode:JSON_UNESCAPED_SLASHES};
					document.querySelector("#pdfCanvasContainer > iframe").setAttribute("src", urlBase + encodeURIComponent(pdfUrl));
				{rdelim});
			</script>

			<div id="pdfCanvasContainer" class="offset-lg-1 col-lg-10 galley__content" style="overflow: visible; -webkit-overflow-scrolling: touch;">
				<iframe src="" width="100%" height="100%" style="min-height: 500px;" title="{$galleyTitle|escape}" allowfullscreen webkitallowfullscreen></iframe>
			</div>
		</div>
	</main>

	{include file="frontend/components/footer.tpl"}
