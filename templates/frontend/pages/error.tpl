{**
 * templates/frontend/pages/error.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2000-2018 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Generic error page.
 * Displays a simple error message and (optionally) a return link.
 *}
{include file="frontend/components/header.tpl"}

<main class="container main__content" id="main">
	<div class="row">
		<div class="offset-md-1 col-md-10 offset-lg-2 col-lg-8">
			<header class="main__header">
				<h1 class="main__title">
					<span>{translate key=$pageTitle}</span>
				</h1>
			</header>
			<div>
				{translate key=$errorMsg params=$errorParams}
			</div>
			{if $backLink}
				<div>
					<a href="{$backLink}">{translate key=$backLinkLabel}</a>
				</div>
			{/if}
		</div>
	</div>
</main>

{include file="frontend/components/footer.tpl"}
