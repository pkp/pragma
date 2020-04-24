{**
 * templates/frontend/pages/message.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2000-2019 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Generic message page.
 * Displays a simple message and (optionally) a return link.
 *}
{include file="frontend/components/header.tpl"}

<main class="container main__content" id="main">
	<div class="row">
		<div class="offset-md-1 col-md-10 offset-lg-2 col-lg-8">
			<header class="main__header">
				<h1 class="main__title">
					<span>{translate key="user.subscriptions.purchaseIndividualSubscription"}</span>
				</h1>
			</header>

			{if $messageTranslated}
				{$messageTranslated}
			{else}
				{translate key=$message}
			{/if}


			{if $backLink}
				<p class="cmp_back_link">
					<a class="btn btn-primary" href="{$backLink}">{translate key=$backLinkLabel}</a>
				</p>
			{/if}
		</div>
	</div>
</main>

{include file="frontend/components/footer.tpl"}
