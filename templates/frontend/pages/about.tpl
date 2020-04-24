{**
 * templates/frontend/pages/about.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to view a journal's or press's description, contact
 *  details, policies and more.
 *
 * @uses $currentContext Journal|Press The current journal or press
 *}
{include file="frontend/components/header.tpl" pageTitle="about.aboutContext"}

<main class="container main__content" id="main">
	<div class="row">
		<div class="offset-md-1 col-md-10 offset-lg-2 col-lg-8">
			<header class="main__header">
				<h1 class="main__title">{translate key="about.aboutContext"}</h1>
				{include file="frontend/components/editLink.tpl" page="management" op="settings" path="context" anchor="masthead" sectionTitleKey="about.aboutContext"}
			</header>
			<div>
				{$currentContext->getLocalizedSetting('description')}
				<hr>
				{$currentContext->getLocalizedSetting('about')}
			</div>
		</div>
	</div>
</main>

{include file="frontend/components/footer.tpl"}
