{**
* plugins/generic/pdfJsViewer/templates/display.tpl
*
* Copyright (c) 2014-2020 Simon Fraser University
* Copyright (c) 2003-2020 John Willinsky
* Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
*
* @brief Template to view a PDF or HTML galley
*}

{**
* plugins/generic/pdfJsViewer/templates/display.tpl
*
* Copyright (c) 2014-2020 Simon Fraser University
* Copyright (c) 2003-2020 John Willinsky
* Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
*
* Embedded viewing of a PDF galley.
*}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{capture assign="pageTitleTranslated"}{translate key="article.pageTitle" title=$title|escape}{/capture}
{include file="frontend/components/header.tpl"}

<body class="pkp_page_{$requestedPage|escape} pkp_op_{$requestedOp|escape}">

	<main class="container galley">
		<div class="row">
			<header class="offset-lg-1 col-lg-10 galley__header">
				<p>
					<a href="{$parentUrl}" class="btn btn-secondary">
						&larr;
						{if $parent instanceOf Issue}
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
				<h1>{$title|escape}</h1>

				{if !$isLatestPublication}
					<div role="alert">
						{translate key="submission.outdatedVersion" datePublished=$galleyPublication->getData('datePublished')|date_format:$dateFormatLong urlRecentVersion=$parentUrl}
					</div>
				{/if}
			</header>

			<div id="pdfCanvasContainer" class="offset-lg-1 col-lg-10 galley__content" style="overflow: visible; -webkit-overflow-scrolling: touch;">
				<iframe src="{$pluginUrl}/pdf.js/web/viewer.html?file={$pdfUrl|escape:"url"}" width="100%" height="100%" style="min-height: 500px;" allowfullscreen webkitallowfullscreen></iframe>
			</div>
		</div>
	</main>

	{call_hook name="Templates::Common::Footer::PageFooter"}
	{include file="frontend/components/footer.tpl"}
</body>
</html>
