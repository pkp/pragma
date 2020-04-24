{**
 * templates/frontend/pages/userSubscriptions.tpl
 *
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Page where users can view and manage their subscriptions.
 *
 * @uses $paymentsEnabled boolean
 * @uses $individualSubscriptionTypesExist boolean Have any individual
 *       subscription types been created?
 * @uses $userIndividualSubscription IndividualSubscription
 * @uses $institutionalSubscriptionTypesExist boolean Have any institutional
 *			subscription types been created?
 * @uses $userInstitutionalSubscriptions array
 *}
{include file="frontend/components/header.tpl" pageTitle="user.subscriptions.mySubscriptions"}

<main class="container main__content" id="main">
	<div class="row">
		<div class="offset-md-1 col-md-10 offset-lg-2 col-lg-8">
			<header class="main__header">
				<h1 class="main__title">
					<span>{translate key="user.subscriptions.mySubscriptions"}</span>
				</h1>
			</header>

			{include file="frontend/components/subscriptionContact.tpl"}

			{if $paymentsEnabled}
				<section>
					<h3>{translate key="user.subscriptions.subscriptionStatus"}</h3>
					<p>{translate key="user.subscriptions.statusInformation"}</p>
					<table>
						<thead>
						<tr>
							<th>{translate key="user.subscriptions.status"}</th>
							<th>{translate key="user.subscriptions.statusDescription"}</th>
						</tr>
						</thead>
						<tbody>
						<tr>
							<td>{translate key="subscriptions.status.needsInformation"}</td>
							<td>{translate key="user.subscriptions.status.needsInformationDescription"}</td>
						</tr>
						<tr>
							<td>{translate key="subscriptions.status.needsApproval"}</td>
							<td>{translate key="user.subscriptions.status.needsApprovalDescription"}</td>
						</tr>
						<tr>
							<td>{translate key="subscriptions.status.awaitingManualPayment"}</td>
							<td>{translate key="user.subscriptions.status.awaitingManualPaymentDescription"}</td>
						</tr>
						<tr>
							<td>{translate key="subscriptions.status.awaitingOnlinePayment"}</td>
							<td>{translate key="user.subscriptions.status.awaitingOnlinePaymentDescription"}</td>
						</tr>
						</tbody>
					</table>
				</section>
			{/if}

			{if $individualSubscriptionTypesExist}
				<section>
					<h3>{translate key="user.subscriptions.individualSubscriptions"}</h3>
					<p>{translate key="subscriptions.individualDescription"}</p>
					{if $userIndividualSubscription}
						<table>
							<thead>
							<tr>
								<th>{translate key="user.subscriptions.form.typeId"}</th>
								<th>{translate key="subscriptions.status"}</th>
								{if $paymentsEnabled}
									<th></th>
								{/if}
							</tr>
							</thead>
							<tbody>
							<tr>
								<td>{$userIndividualSubscription->getSubscriptionTypeName()|escape}</td>
								<td>
									{assign var="subscriptionStatus" value=$userIndividualSubscription->getStatus()}
									{assign var="isNonExpiring" value=$userIndividualSubscription->isNonExpiring()}
									{if $paymentsEnabled && $subscriptionStatus == $smarty.const.SUBSCRIPTION_STATUS_AWAITING_ONLINE_PAYMENT}
										<span>
										{translate key="subscriptions.status.awaitingOnlinePayment"}
									</span>
									{elseif $paymentsEnabled && $subscriptionStatus == $smarty.const.SUBSCRIPTION_STATUS_AWAITING_MANUAL_PAYMENT}
										<span>
										{translate key="subscriptions.status.awaitingManualPayment"}
									</span>
									{elseif $subscriptionStatus != $smarty.const.SUBSCRIPTION_STATUS_ACTIVE}
										<span>
										{translate key="subscriptions.inactive"}
									</span>
									{else}
										{if $isNonExpiring}
											{translate key="subscriptionTypes.nonExpiring"}
										{else}
											{assign var="isExpired" value=$userIndividualSubscription->isExpired()}
											{if $isExpired}
												<span>
												{translate key="user.subscriptions.expired" date=$userIndividualSubscription->getDateEnd()|date_format:$dateFormatShort}
											</span>
											{else}
												<span>
												{translate key="user.subscriptions.expires" date=$userIndividualSubscription->getDateEnd()|date_format:$dateFormatShort}
											</span>
											{/if}
										{/if}
									{/if}
								</td>
								{if $paymentsEnabled}
									<td>
										{if $subscriptionStatus == $smarty.const.SUBSCRIPTION_STATUS_AWAITING_ONLINE_PAYMENT}
											<a href="{url op="completePurchaseSubscription" path="individual"|to_array:$userIndividualSubscription->getId()}">
												{translate key="user.subscriptions.purchase"}
											</a>
										{elseif $subscriptionStatus == $smarty.const.SUBSCRIPTION_STATUS_ACTIVE}
											{if !$isNonExpiring}
												<a href="{url op="payRenewSubscription" path="individual"|to_array:$userIndividualSubscription->getId()}">
													{translate key="user.subscriptions.renew"}
												</a>
											{/if}
											<a href="{url op="purchaseSubscription" path="individual"|to_array:$userIndividualSubscription->getId()}">
												{translate key="user.subscriptions.purchase"}
											</a>
										{/if}
									</td>
								{/if}
							</tr>
							</tbody>
						</table>
					{elseif $paymentsEnabled}
						<p>
							<a class="btn btn-primary" href="{url op="purchaseSubscription" path="individual"}">
								{translate key="user.subscriptions.purchaseNewSubscription"}
							</a>
						</p>
					{else}
						<p>
							<a href="{url page="about" op="subscriptions" anchor="subscriptionTypes"}">
								{translate key="user.subscriptions.viewSubscriptionTypes"}
							</a>
						</p>
					{/if}
				</section>
			{/if}

			{if $institutionalSubscriptionTypesExist}
				<section>
					<h3>{translate key="user.subscriptions.institutionalSubscriptions"}</h3>
					<p>
						{translate key="subscriptions.institutionalDescription"}
						{if $paymentsEnabled}
							{translate key="subscriptions.institutionalOnlinePaymentDescription"}
						{/if}
					</p>
					{if $userInstitutionalSubscriptions}
						<table>
							<thead>
							<tr>
								<th>{translate key="user.subscriptions.form.typeId"}</th>
								<th>{translate key="user.subscriptions.form.institutionName"}</th>
								<th>{translate key="subscriptions.status"}</th>
								{if $paymentsEnabled}
									<th></th>
								{/if}
							</tr>
							</thead>
							<tbody>
								{iterate from=userInstitutionalSubscriptions item=userInstitutionalSubscription}
									<tr>
										<td>{$userInstitutionalSubscription->getSubscriptionTypeName()|escape}</td>
										<td>{$userInstitutionalSubscription->getInstitutionName()|escape}</td>
										<td>
											{assign var="subscriptionStatus" value=$userInstitutionalSubscription->getStatus()}
											{assign var="isNonExpiring" value=$userInstitutionalSubscription->isNonExpiring()}
											{if $paymentsEnabled && $subscriptionStatus == $smarty.const.SUBSCRIPTION_STATUS_AWAITING_ONLINE_PAYMENT}
												<span>
											{translate key="subscriptions.status.awaitingOnlinePayment"}
										</span>
											{elseif $paymentsEnabled && $subscriptionStatus == $smarty.const.SUBSCRIPTION_STATUS_AWAITING_MANUAL_PAYMENT}
												<span>
											{translate key="subscriptions.status.awaitingManualPayment"}
										</span>
											{elseif $paymentsEnabled && $subscriptionStatus == $smarty.const.SUBSCRIPTION_STATUS_NEEDS_APPROVAL}
												<span>
											{translate key="subscriptions.status.needsApproval"}
										</span>
											{elseif $subscriptionStatus != $smarty.const.SUBSCRIPTION_STATUS_ACTIVE}
												<span>
											{translate key="subscriptions.inactive"}
										</span>
											{else}
												{if $isNonExpiring}
													<span>
												{translate key="subscriptionTypes.nonExpiring"}
											</span>
												{else}
													{assign var="isExpired" value=$userInstitutionalSubscription->isExpired()}
													{if $isExpired}
														<span>
													{translate key="user.subscriptions.expired" date=$userInstitutionalSubscription->getDateEnd()|date_format:$dateFormatShort}
												</span>
													{else}
														<span>
													{translate key="user.subscriptions.expires" date=$userInstitutionalSubscription->getDateEnd()|date_format:$dateFormatShort}
												</span>
													{/if}
												{/if}
											{/if}
										</td>
										{if $paymentsEnabled}
											<td>
												{if $subscriptionStatus == $smarty.const.SUBSCRIPTION_STATUS_AWAITING_ONLINE_PAYMENT}
													<a href="{url op="completePurchaseSubscription" path="institutional"|to_array:$userInstitutionalSubscription->getId()}">
														{translate key="user.subscriptions.purchase"}
													</a>
												{elseif $subscriptionStatus == $smarty.const.SUBSCRIPTION_STATUS_ACTIVE}
													{if !$isNonExpiring}
														<a href="{url op="payRenewSubscription" path="institutional"|to_array:$userInstitutionalSubscription->getId()}">
															{translate key="user.subscriptions.renew"}
														</a>
													{/if}
													<a href="{url op="purchaseSubscription" path="institutional"|to_array:$userInstitutionalSubscription->getId()}">
														{translate key="user.subscriptions.purchase"}
													</a>
												{/if}
											</td>
										{/if}
									</tr>
								{/iterate}
							</tbody>
						</table>
					{/if}
					<p>
						{if $paymentsEnabled}
							<a class="btn btn-primary" href="{url page="user" op="purchaseSubscription" path="institutional"}">
								{translate key="user.subscriptions.purchaseNewSubscription"}
							</a>
						{else}
							<a href="{url page="about" op="subscriptions" anchor="subscriptionTypes"}">
								{translate key="user.subscriptions.viewSubscriptionTypes"}
							</a>
						{/if}
					</p>
				</section>
			{/if}
		</div>
	</div>
</main>

{include file="frontend/components/footer.tpl"}
