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
<head>
	<meta http-equiv="Content-Type" content="text/html; charset={$defaultCharset|escape}" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>{translate key="article.pageTitle" title=$title|escape}</title>

	{load_header context="frontend" headers=$headers}
	{load_stylesheet context="frontend" stylesheets=$stylesheets}
	{load_script context="frontend" scripts=$scripts}
</head>
<body class="pkp_page_{$requestedPage|escape} pkp_op_{$requestedOp|escape}">
	{include file="frontend/components/header.tpl"}

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
						<span class="sr-only">
							{translate key="common.downloadPdf"}
						</span>
					</a>
				</p>
				<h1>{$article->getLocalizedTitle()|escape}</h1>

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
