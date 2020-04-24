{**
 * templates/frontend/pages/userRegister.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * User registration form.
 *
 * @uses $primaryLocale string The primary locale for this journal/press
 *}
{include file="frontend/components/header.tpl" pageTitle="user.register"}

<main class="container page_register main__content" id="main">
	<div class="row">
		<div class="offset-md-1 col-md-10 offset-lg-2 col-lg-8">
			<header class="main__header">
				<h1 class="main__title">
					<span>{translate key="user.register"}</span>
				</h1>
			</header>

			<form class="cmp_form register" id="register" method="post" action="{url op="register"}">
				{csrf}

				{if $source}
				<input type="hidden" name="source" value="{$source|escape}" />
				{/if}

				{include file="common/formErrors.tpl"}

				{include file="frontend/components/registrationForm.tpl"}

				{* When a user is registering with a specific journal *}
				{if $currentContext}

				<fieldset class="consent">
					<div class="form-group">
						{if $currentContext->getSetting('privacyStatement')}
							{* Require the user to agree to the terms of the privacy policy *}
							<div class="custom-control custom-checkbox optin optin-privacy">
								<input type="checkbox" class="custom-control-input" name="privacyConsent" id="privacyConsent" value="1"{if $privacyConsent} checked="checked"{/if}>
								<label for="privacyConsent" class="custom-control-label">
									{capture assign="privacyUrl"}{url router=$smarty.const.ROUTE_PAGE page="about" op="privacy"}{/capture}
									{translate key="user.register.form.privacyConsent" privacyUrl=$privacyUrl}
								</label>
							</div>
						{/if}
					{* Ask the user to opt into public email notifications *}

						<div class="custom-control custom-checkbox optin optin-email">
							<input type="checkbox" class="custom-control-input" name="emailConsent" id="emailConsent" value="1"{if $emailConsent} checked="checked"{/if}>
							<label for="emailConsent" class="custom-control-label">
								{translate key="user.register.form.emailConsent"}
							</label>
						</div>
					</div>
				</fieldset>

				{* Allow the user to sign up as a reviewer *}
				{assign var=contextId value=$currentContext->getId()}
				{assign var=userCanRegisterReviewer value=0}
				{foreach from=$reviewerUserGroups[$contextId] item=userGroup}
				{if $userGroup->getPermitSelfRegistration()}
				{assign var=userCanRegisterReviewer value=$userCanRegisterReviewer+1}
				{/if}
				{/foreach}
				{if $userCanRegisterReviewer}
				<fieldset class="reviewer">
					{if $userCanRegisterReviewer > 1}
					<legend>
						{translate key="user.reviewerPrompt"}
					</legend>
					{capture assign="checkboxLocaleKey"}user.reviewerPrompt.userGroup{/capture}
					{else}
					{capture assign="checkboxLocaleKey"}user.reviewerPrompt.optin{/capture}
					{/if}
					<div class="form-group">
						<div id="reviewerOptinGroup" class="custom-control custom-checkbox optin">
							{foreach from=$reviewerUserGroups[$contextId] item=userGroup}
							{if $userGroup->getPermitSelfRegistration()}

							{assign var="userGroupId" value=$userGroup->getId()}
							<input type="checkbox" class="custom-control-input" id="checkbox-reviewer-interests" name="reviewerGroup[{$userGroupId}]" value="1"{if in_array($userGroupId, $userGroupIds)} checked="checked"{/if}>
							<label for="checkbox-reviewer-interests" class="custom-control-label">
								{translate key=$checkboxLocaleKey userGroup=$userGroup->getLocalizedName()}
							</label>
							{/if}
							{/foreach}
						</div>

						<div id="reviewerInterests" class="reviewer_interests hidden">
							{*
							* This container will be processed by the tag-it jQuery
							* plugin. In order for it to work, your theme will need to
							* load the jQuery tag-it plugin and initialize the
							* component.
							*
							* Two data attributes are added which are not a default
							* feature of the plugin. These are converted into options
							* when the plugin is initialized on the element.
							*
							* See: /plugins/themes/default/js/main.js
							*
							* `data-field-name` represents the name used to POST the
							* interests when the form is submitted.
							*
							* `data-autocomplete-url` is the URL used to request
							* existing entries from the server.
							*
							* @link: http://aehlke.github.io/tag-it/
							*}
							<div class="label">
								{translate key="user.interests"}
							</div>
							<ul id="tagitInput" class="interests tag-it" data-field-name="interests[]" data-autocomplete-url="{url|escape router=$smarty.const.ROUTE_PAGE page='user' op='getInterests'}">
								{foreach from=$interests item=interest}
								<li>{$interest|escape}</li>
								{/foreach}
							</ul>
						</div>
					</div>
				</fieldset>
				{/if}
				{/if}

				{include file="frontend/components/registrationFormContexts.tpl"}

				{* recaptcha spam blocker *}
				{if $reCaptchaHtml}
					<fieldset class="recaptcha_wrapper">
						<div class="fields">
							<div class="recaptcha">
								{$reCaptchaHtml}
							</div>
						</div>
					</fieldset>
				{/if}

				<div class="form-group">
					<button class="btn btn-primary" type="submit">
						{translate key="user.register"}
					</button>

					{capture assign="rolesProfileUrl"}{url page="user" op="profile" path="roles"}{/capture}
					<a href="{url page="login" source=$rolesProfileUrl}" class="btn btn-secondary">{translate key="user.login"}</a>
				</div>
			</form>
		</div>
	</div><!-- row -->
</main><!-- page container -->

{include file="frontend/components/footer.tpl"}
