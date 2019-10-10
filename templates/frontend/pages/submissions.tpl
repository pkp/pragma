{**
 * templates/frontend/pages/submissions.tpl
 *
 * Copyright (c) 2014-2019 Simon Fraser University
 * Copyright (c) 2003-2019 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to view the editorial team.
 *
 * @uses $currentContext Journal|Press The current journal or press
 * @uses $submissionChecklist array List of requirements for submissions
 *}
{include file="frontend/components/header.tpl" pageTitle="about.submissions"}

<main class="container main__content" id="main">
	<div class="row">
		<div class="offset-md-1 col-md-10 offset-lg-2 col-lg-8">
			<header class="main__header">
				<h1 class="main__title">
					<span>{translate key="about.submissions"}</span>
				</h1>
			</header>

			{* Login/register prompt *}
			{if $isUserLoggedIn}
				{capture assign="newSubmission"}<a
					href="{url page="submission" op="wizard"}">{translate key="about.onlineSubmissions.newSubmission"}</a>{/capture}
				{capture assign="viewSubmissions"}<a
					href="{url page="submissions"}">{translate key="about.onlineSubmissions.viewSubmissions"}</a>{/capture}
				<div>
					{translate key="about.onlineSubmissions.submissionActions" newSubmission=$newSubmission viewSubmissions=$viewSubmissions}
				</div>
			{else}
				{capture assign="login"}<a
					href="{url page="login"}">{translate key="about.onlineSubmissions.login"}</a>{/capture}
				{capture assign="register"}<a
					href="{url page="user" op="register"}">{translate key="about.onlineSubmissions.register"}</a>{/capture}
				<div>
					{translate key="about.onlineSubmissions.registrationRequired" login=$login register=$register}
				</div>
			{/if}

			{if $submissionChecklist}
				<section>
					{include file="frontend/components/editLink.tpl" page="management" op="settings" path="publication" anchor="submissionStage" sectionTitleKey="about.submissionPreparationChecklist"}
					<h2>
						{translate key="about.submissionPreparationChecklist"}
					</h2>
					<p>{translate key="about.submissionPreparationChecklist.description"}</p>
					<ul>
						{foreach from=$submissionChecklist item=checklistItem}
							<li>
								{$checklistItem.content|strip_unsafe_html|nl2br}
							</li>
						{/foreach}
					</ul>
				</section>
			{/if}

			{if $currentContext->getLocalizedSetting('authorGuidelines')}
				<section id="authorGuidelines">
					{include file="frontend/components/editLink.tpl" page="management" op="settings" path="publication" anchor="submissionStage" sectionTitleKey="about.authorGuidelines"}
					<h2>
						{translate key="about.authorGuidelines"}
					</h2>
					{$currentContext->getLocalizedSetting('authorGuidelines')}
				</section>
			{/if}

			{if $currentContext->getLocalizedSetting('copyrightNotice')}
				<section>
					{include file="frontend/components/editLink.tpl" page="management" op="settings" path="distribution" anchor="permissions" sectionTitleKey="about.copyrightNotice"}
					<h2>
						{translate key="about.copyrightNotice"}
					</h2>
					{$currentContext->getLocalizedSetting('copyrightNotice')}
				</section>
			{/if}

			{if $currentContext->getLocalizedSetting('privacyStatement')}
				<section>
					{include file="frontend/components/editLink.tpl" page="management" op="settings" path="publication" anchor="submissionStage" sectionTitleKey="about.privacyStatement"}
					<h2>
						{translate key="about.privacyStatement"}
					</h2>
					{$currentContext->getLocalizedSetting('privacyStatement')}
				</section>
			{/if}
		</div>
	</div> <!-- .row -->
</main>

{include file="frontend/components/footer.tpl"}
