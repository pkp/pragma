{**
 * templates/frontend/components/registrationFormContexts.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Display role selection for all of the journals/presses on this site
 *
 * @uses $contexts array List of journals/presses on this site that have enabled registration
 * @uses $readerUserGroups array Associative array of user groups with reader
 *  permissions in each context.
 * @uses $authorUserGroups array Associative array of user groups with author
 *  permissions in each context.
 * @uses $reviewerUserGroups array Associative array of user groups with reviewer
 *  permissions in each context.
 * @uses $userGroupIds array List group IDs this user is assigned
 *}

{* Only display the context role selection when registration is taking place
   outside of the context of any one journal/press. *}
{if !$currentContext}

	{* Allow users to register for any journal/press on this site *}
	<fieldset name="contexts">
		<legend>
			{translate key="user.register.contextsPrompt"}
		</legend>
		<div id="contextOptinGroup">
			{foreach from=$contexts item=context}
				{assign var=contextId value=$context->getId()}
				{assign var=isSelected value=false}
				<fieldset>
					{capture assign="contextUrl"}{url router=$smarty.const.ROUTE_PAGE context=$context->getPath()}{/capture}
					<legend>
						<a href="{$contextUrl|escape}" class="registration-context__name">
							{$context->getLocalizedName()|escape}
						</a>
					</legend>
					<fieldset class="registration-context__roles">
						<legend>
							{translate key="user.register.otherContextRoles"}
						</legend>
						<div class="custom-control custom-checkbox">
							{foreach from=$readerUserGroups[$contextId] item=userGroup}
								{if $userGroup->getPermitSelfRegistration()}
									{assign var="userGroupId" value=$userGroup->getId()}
									<input type="checkbox" class="custom-control-input" id="readerGroup[{$userGroupId}]" name="readerGroup[{$userGroupId}]"{if in_array($userGroupId, $userGroupIds)} checked="checked"{/if}>
									<label for="readerGroup[{$userGroupId}]" class="custom-control-label">
										{$userGroup->getLocalizedName()}
									</label>
									{if in_array($userGroupId, $userGroupIds)}
										{assign var=isSelected value=true}
									{/if}
								{/if}
							{/foreach}
						</div>
						<div class="custom-control custom-checkbox">
							{foreach from=$reviewerUserGroups[$contextId] item=userGroup}
								{if $userGroup->getPermitSelfRegistration()}
									{assign var="userGroupId" value=$userGroup->getId()}
									<input type="checkbox" class="custom-control-input" id="reviewerGroup[{$userGroupId}]" name="reviewerGroup[{$userGroupId}]"{if in_array($userGroupId, $userGroupIds)} checked="checked"{/if}>
									<label for="reviewerGroup[{$userGroupId}]" class="custom-control-label">
										{$userGroup->getLocalizedName()}
									</label>
									{if in_array($userGroupId, $userGroupIds)}
										{assign var=isSelected value=true}
									{/if}
								{/if}
							{/foreach}
						</div>
					</fieldset>
					{* Require the user to agree to the terms of the context's privacy policy *}
					{if !$enableSiteWidePrivacyStatement && $context->getSetting('privacyStatement')}
						<div class="custom-control custom-checkbox {if $isSelected}context_privacy_visible{/if}">
							<input type="checkbox" class="custom-control-input" name="privacyConsent[{$contextId}]" id="privacyConsent[{$contextId}]" value="1"{if $privacyConsent[$contextId]} checked="checked"{/if}>
							<label for="privacyConsent[{$contextId}]" class="custom-control-label">
								{capture assign="privacyUrl"}{url router=$smarty.const.ROUTE_PAGE context=$context->getPath() page="about" op="privacy"}{/capture}
								{translate key="user.register.form.privacyConsentThisContext" privacyUrl=$privacyUrl}
							</label>
						</div>
					{/if}
				</fieldset>
			{/foreach}
		</div>
	</fieldset>

	{* When a user is registering for no specific journal, allow them to
				enter their reviewer interests *}
	<fieldset class="reviewer_nocontext_interests">
		<legend>
			{translate key="user.register.noContextReviewerInterests"}
		</legend>
		<div class="reviewer_nocontext_interests">
			{* See comment for .tag-it above *}
			<ul id="tagitInput" class="interests tag-it" data-field-name="interests[]" data-autocomplete-url="{url|escape router=$smarty.const.ROUTE_PAGE page='user' op='getInterests'}">
				{foreach from=$interests item=interest}
					<li>{$interest|escape}</li>
				{/foreach}
			</ul>
		</div>
	</fieldset>

	{* Require the user to agree to the terms of the privacy policy *}
	<div class="form-group">
	{if $siteWidePrivacyStatement}
		<div class="custom-control custom-checkbox optin optin-privacy">
			<input type="checkbox" class="custom-control-input" name="privacyConsent[{$smarty.const.CONTEXT_ID_NONE}]" id="privacyConsent[{$smarty.const.CONTEXT_ID_NONE}]" value="1"{if $privacyConsent[$smarty.const.CONTEXT_ID_NONE]} checked="checked"{/if}>
			<label for="privacyConsent[{$smarty.const.CONTEXT_ID_NONE}]" class="custom-control-label">
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
{/if}
