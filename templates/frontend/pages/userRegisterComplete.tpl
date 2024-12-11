{**
 * templates/frontend/pages/userRegisterComplete.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief A landing page displayed to users upon successful registration
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

			<p>
				{translate key="user.login.registrationComplete.instructions"}
			</p>
			<ul>
				{if array_intersect(array(\PKP\security\Role::ROLE_ID_MANAGER, \PKP\security\Role::ROLE_ID_SUB_EDITOR, \PKP\security\Role::ROLE_ID_ASSISTANT, \PKP\security\Role::ROLE_ID_REVIEWER), (array)$userRoles)}
					<li>
						<a href="{url page="submissions"}">
							{translate key="user.login.registrationComplete.manageSubmissions"}
						</a>
					</li>
				{/if}
				{if $currentContext}
					<li>
						<a href="{url page="submission" op="wizard"}">
							{translate key="user.login.registrationComplete.newSubmission"}
						</a>
					</li>
				{/if}
				<li>
					<a href="{url router=$smarty.const.ROUTE_PAGE page="user" op="profile"}">
						{translate key="user.editMyProfile"}
					</a>
				</li>
				<li>
					<a href="{url page="index"}">
						{translate key="user.login.registrationComplete.continueBrowsing"}
					</a>
				</li>
			</ul>
			</ul>
		</div>
	</div>
</main>

{include file="frontend/components/footer.tpl"}
