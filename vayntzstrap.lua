-- Vaystrap Mobile V1
if getgenv().VaystrapLastLoad then
    if os.clock() - getgenv().VaystrapLastLoad < 5 then
        return -- Prevent duplicate execution from autoexec + queue_on_teleport race conditions
    end
end
getgenv().VaystrapLastLoad = os.clock()

if getgenv().VaystrapUnload then
    pcall(getgenv().VaystrapUnload)
end

local function cleanupOld()
    local cg = game:GetService("CoreGui")
    local pg = game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if cg and cg:FindFirstChild("VaystrapMobile") then cg.VaystrapMobile:Destroy() end
    if pg and pg:FindFirstChild("VaystrapMobile") then pg.VaystrapMobile:Destroy() end
end
cleanupOld()

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

local guiContainer = game:GetService("CoreGui")
if getgenv and type(getgenv().gethui) == "function" then
    local ok, h = pcall(getgenv().gethui)
    if ok and h then guiContainer = h end
end
if not guiContainer then
    local ok, h = pcall(function() return player:WaitForChild("PlayerGui") end)
    if ok and h then guiContainer = h end
end

local gui = Instance.new("ScreenGui")
gui.Name = "VaystrapMobile"
gui.ResetOnSpawn = false
gui.DisplayOrder = 99999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.IgnoreGuiInset = true
gui.Parent = guiContainer

local C = {
    bg       = Color3.fromRGB(8, 8, 8),
    bg2      = Color3.fromRGB(12, 12, 12),
    surface  = Color3.fromRGB(16, 16, 16),
    surface2 = Color3.fromRGB(22, 22, 22),
    surface3 = Color3.fromRGB(28, 28, 28),
    border   = Color3.fromRGB(38, 38, 38),
    borderL  = Color3.fromRGB(55, 55, 55),
    muted    = Color3.fromRGB(110, 110, 110),
    dim      = Color3.fromRGB(70, 70, 70),
    white    = Color3.fromRGB(235, 235, 235),
    pure     = Color3.fromRGB(255, 255, 255),
}

local vp = Vector2.new(1280, 720)
local okVp, camVp = pcall(function() return workspace.CurrentCamera.ViewportSize end)
if okVp then vp = camVp end

local WIN_W = math.min(800, math.max(560, vp.X * 0.70))
local WIN_H = math.min(560, math.max(420, vp.Y * 0.75))
local SIDEBAR_W = 52
local HEADER_H = 48
local PAD = 14

local function rounded(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = p
    return c
end

local function stroke(p, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or C.border
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = p
    return s
end

local function pad(p, l, t, r, b)
    local u = Instance.new("UIPadding")
    u.PaddingLeft = UDim.new(0, l or 0)
    u.PaddingTop = UDim.new(0, t or 0)
    u.PaddingRight = UDim.new(0, r or 0)
    u.PaddingBottom = UDim.new(0, b or 0)
    u.Parent = p
    return u
end

local function hasGroupTransparency(inst)
    local ok, v = pcall(function() return inst.GroupTransparency end)
    return ok and v ~= nil
end

local function btnFx(btn, hoverCol, pressCol)
    local base = btn.BackgroundColor3
    local hc = hoverCol or Color3.fromRGB(32, 32, 32)
    local pc = pressCol or Color3.fromRGB(18, 18, 18)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = hc}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = base}):Play()
    end)
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.06), {BackgroundColor3 = pc}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = hc}):Play()
    end)
end

local function dragWindow(win, bar)
    local dragging, startPos, startFrame
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = input.Position
            startFrame = win.Position
        end
    end)
    bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - startPos
            win.Position = UDim2.new(startFrame.X.Scale, startFrame.X.Offset + d.X, startFrame.Y.Scale, startFrame.Y.Offset + d.Y)
        end
    end)
end

local SVG_EDITOR = "??"

local SVG_DATABASE = "???"

local SVG_PRESETS = "??"

local SVG_SETTINGS = "??"

local SVG_ABOUT = "??"

local SVG_APPLY = "??"

local SVG_PASTE = "??"

local SVG_REJOIN = "??"

local SVG_DISCORD = "[D]"

local SVG_YOUTUBE = "[Y]"

local SVG_GITHUB = "[G]"

local SVG_ANDROID = "??"

local SVG_IOS = "??"

local PRESETS = {
    {
        name = "FPS Boost",
        desc = "General performance optimization flags",
        flags = {
            ["FStringTerrainMaterialTablePre2022"] = "",
            ["DFFlagUnifyLegacyJointGeometry"] = "True",
            ["FFlagDebugForceFSMCPULightCulling"] = "True",
            ["FFlagAdaptiveScrollingFrameOnServer"] = "True",
            ["FFlagEnablePreferredTextSizeGuiService"] = "True",
            ["FFlagDebugEnableVRFTUXExperienceInStudio"] = "True",
            ["DFFlagAudioEnableVolumetricPanningForPolys"] = "True",
            ["DFStringTelegrafAddress"] = "127.0.0.1",
            ["FFlagPreferredTextSizeSettingBetaFeature"] = "True",
            ["FFlagAXAdaptiveScrollingAvatarEditor2"] = "True",
            ["FFlagRemovedRbxRenderingPreProcessor"] = "False",
            ["FFlagEnablePreferredTextSizeStyleFixesInAppShell3"] = "True",
            ["FFlagSortKeyOptimization"] = "True",
            ["FFlagDebugDeterministicParticles"] = "False",
            ["DFIntCullFactorPixelThresholdShadowMapLowQuality"] = "2147483647",
            ["FFlagEnableV3MenuABTest3"] = "True",
            ["FIntBloomFrmCutoff"] = "-1",
            ["FFlagLuaAppsEnableParentalControlsTab"] = "False",
            ["FFlagEnableInGameMenuModernization"] = "False",
            ["FIntVRTouchControllerTransparency"] = "0",
            ["FIntSmoothTerrainPhysicsCacheSize"] = "2147483647",
            ["FFlagVRMouseMoveOptimization"] = "True",
            ["FFlagSettingsHubIndependentBackgroundVisibility"] = "True",
            ["FFlagEnableExperienceNotificationPrompts2"] = "False",
            ["FFlagRenderLightGridEfficientTextureAtlasUpdate"] = "True",
            ["DFFlagDebugRenderForceTechnologyVoxel"] = "True",
            ["FIntRobloxGuiBlurIntensity"] = "0",
            ["DFFlagEnablePerfRenderStatsCollection2"] = "false",
            ["DFFlagEnableSoundPreloading"] = "True",
            ["DFFlagSimDcdRecompUseClosedVoxel4"] = "True",
            ["FFlagGuiHidingApiSupport2"] = "True",
            ["DFFlagSimOptimizeSetSize"] = "True",
            ["FFlagEnableInGameMenuControls"] = "False",
            ["FFlagSelfViewLookUpHumanoidByType"] = "False",
            ["FIntOcclusionCullingBetaFeatureRolloutPercent"] = "100",
            ["FIntRenderGrassDetailStrands"] = "0",
            ["FFlagVRFixCursorJitterLua"] = "True",
            ["FFlagLuaMenuPerfImprovements"] = "True",
            ["DFIntAnimationLodFacsVisibilityDenominator"] = "0",
            ["FFlagFixSensitivityTextPrecision"] = "False",
            ["DFIntDefaultTimeoutTimeMs"] = "10000",
            ["FFlagPreloadTextureItemsOption4"] = "True",
            ["FFlagDebugDisableTelemetryEphemeralStat"] = "True",
            ["FFlagSquadToastNotificationsEnabled"] = "False",
            ["DFIntWaitOnRecvFromLoopEndedMS"] = "100",
            ["FFlagFixChunkLightingUpdate2"] = "True",
            ["FFlagRenderCBRefactor2"] = "True",
            ["FIntTaskSchedulerThreadMin"] = "3",
            ["FFlagEnableVisBugChecks27"] = "True",
            ["FFlagCAP1544UseNewDataSharingRollout"] = "False",
            ["DFFlagUseVisBugChecks"] = "True",
            ["FFlagOcclusionCullingBetaFeature"] = "True",
            ["DFIntTimestepArbiterThresholdCFLThou"] = "300",
            ["FFlagNewOptimizeNoCollisionPrimitiveInMidphase637"] = "True",
            ["DFFlagReportServerConnectionLost"] = "False",
            ["DFIntCullFactorPixelThresholdShadowMapHighQuality"] = "2147483647",
            ["DFIntVideoMaxNumberOfVideosPlaying"] = "0",
            ["FFlagToastNotificationsResendDisplayOnInit"] = "False",
            ["FIntBootstrapperWebView2InstallationTelemetryHundredthPercent"] = "0",
            ["FIntEnableVisBugChecksHundredthPercent27"] = "100",
            ["FFlagEngineAPICloudProcessingUseNotificationClient"] = "False",
            ["FFlagAvatarChatIncludeSelfViewOnTelemetry"] = "False",
            ["DFIntContentProviderPreloadHangTelemetryHundredthsPercentage"] = "0",
            ["FFlagRenderTestEnableDistanceCulling"] = "True",
            ["DFIntHACDPointSampleDistApartTenths"] = "2147483647",
            ["FIntRenderMaxShadowAtlasUsageBeforeDownscale"] = "1",
            ["FFlagEnablePreferredTextSizeStyleFixesInCaptureMenu"] = "True",
            ["FFlagFixCountOfUnreadNotificationError"] = "False",
            ["FFlagEnableVRFTUXExperienceV2"] = "True",
            ["DFIntRakNetLoopMs"] = "1",
            ["FFlagDebugEnableDirectAudioOcclusion2"] = "True",
            ["FFlagRemoveRedundantFontPreloading"] = "True",
            ["FFlagDebugForceFutureIsBrightPhase3"] = "True",
            ["DFIntCSGLevelOfDetailSwitchingDistanceL23"] = "0",
            ["FFlagRenderLegacyShadowsQualityRefactor"] = "True",
            ["FIntGrassMovementReducedMotionFactor"] = "0",
            ["DFFlagAudioUseVolumetricPanning"] = "True",
            ["FIntStudioResendDisconnectNotificationInterval"] = "0",
            ["FFlagNotificationsNoLongerRequireControllerState"] = "False",
            ["FIntCAP1544DataSharingUserRolloutPercentage"] = "0",
            ["DFIntRakNetClockDriftAdjustmentPerPingMillisecond"] = "100",
            ["FFlagDebugSelfViewPerfBenchmark"] = "False",
            ["FFlagEnablePreferredTextSizeStyleFixesInPlayerList"] = "True",
            ["DFFlagAudioEnableVolumetricPanningForMeshes"] = "True",
            ["FFlagTaskSchedulerLimitTargetFpsTo2402"] = "False",
            ["DFIntTeleportClientAssetPreloadingHundredthsPercentage"] = "100000",
            ["FFlagFastGPULightCulling3"] = "True",
            ["DFIntDebugLimitMinTextureResolutionWhenSkipMips"] = "0",
            ["FFlagUseNotificationsLocalization"] = "False",
            ["DFIntDebugAdditionalNumberOfMipsToSkipForNonAlbedoTextures"] = "0",
            ["FIntSSAOMipLevels"] = "1",
            ["FStringGetPlayerImageDefaultTimeout"] = "1",
            ["FFlagRenderDebugCheckThreading2"] = "True",
            ["DFFlagOptimizePartsInPart"] = "True",
            ["FFlagShoeSkipRenderMesh"] = "False",
            ["FFlagFixIGMBottomBarVisibility"] = "True",
            ["FFlagMouseGetPartOptimization"] = "True",
            ["DFFlagSimSolverOptimizeGeometricStiffness4"] = "True",
            ["DFIntCSGLevelOfDetailSwitchingDistanceL12"] = "0",
            ["FIntEnableCullableScene2HundredthPercent3"] = "100",
            ["DFIntRaknetBandwidthInfluxHundredthsPercentageV2"] = "10000",
            ["FFlagUserFixLoadAnimationError"] = "True",
            ["FFlagEnablePreferredTextSizeScalePerLayerCollector"] = "True",
            ["FFlagToastNotificationsUpdateEventParams"] = "False",
            ["DFIntDebugRestrictGCDistance"] = "1",
            ["FFlagRenderSkipReadingShaderData"] = "False",
            ["FFlagDebugForceFutureIsBrightPhase2"] = "True",
            ["FFlagPreloadAllFonts"] = "True",
            ["FFlagImproveShiftLockTransition"] = "True",
            ["FFlagRenderFixFog"] = "True",
            ["DFIntMicroProfilerDpiScaleOverride"] = "100",
            ["FFlagRenderEnableGlobalInstancingD3D10"] = "True",
            ["FIntRenderLocalLightUpdatesMin"] = "1",
            ["FFlagEnablePreferredTextSizeScale"] = "True",
            ["FFlagFixSettingsHubVRBackgroundError"] = "True",
            ["FIntCameraMaxZoomDistance"] = "999999",
            ["FFlagVisBugChecksThreadYield"] = "True",
            ["DFIntCSGLevelOfDetailSwitchingDistance"] = "0",
            ["DFStringTelemetryV2Url"] = "http://127.0.0.1:443",
            ["FFlagFixOutdatedTimeScaleParticles"] = "False",
            ["FFlagEnablePreferredTextSizeStyleFixesGameTile"] = "True",
            ["FFlagMigrateTextureManagerIsLocalAsset"] = "True",
            ["FFlagAXPortraitSplitAdaptiveScrollingFix2"] = "True",
            ["FFlagDebugForceGenerateHSR"] = "True",
            ["FFlagEnableBetterHapticsResultHandling"] = "True",
            ["FIntRenderLocalLightFadeInMs"] = "0",
            ["FFlagSelfieViewEnabled"] = "True",
            ["DFFlagDebugPerfMode"] = "True",
            ["FFlagVRLaserPointerOptimization"] = "True",
            ["FFlagDebugGraphicsPreferD3D11FL10"] = "True",
            ["FIntTargetRefreshRate"] = "144",
            ["DFIntTextureQualityOverride"] = "0",
            ["DFFlagTextureQualityOverrideEnabled"] = "True",
            ["DFFlagDisableDPIScale"] = "True",
            ["FIntFontSizePadding"] = "4",
            ["DFIntCanHideGuiGroupId"] = "32380007",
            ["DFIntTaskSchedulerTargetFps"] = "1000",
            ["FIntFullscreenTitleBarTriggerDelayMillis"] = "3600000",
            ["FIntTerrainArraySliceSize"] = "0",
            ["FFlagDisablePostFx"] = "True",
            ["FIntRenderShadowIntensity"] = "0",
            ["FIntDebugForceMSAASamples"] = "1",
            ["FFlagHandleAltEnterFullscreenManually"] = "False",
            ["FLogNetwork"] = "7",
            ["FStringVoiceBetaBadgeLearnMoreLink"] = "null",
            ["FFlagControlBetaBadgeWithGuac"] = "False",
            ["FFlagRenderNoLowFrmBloom"] = "False",
            ["DFIntRakNetMtuValue1InBytes"] = "900",
            ["FFlagNotificationPluginSignalRReadEvents"] = "False",
            ["FIntTextureCompositorLowResFactor"] = "4",
            ["FFlagLoginPageOptimizedPngs"] = "True",
            ["FFlagEnableChildrenLockFromLua2"] = "False",
            ["FFlagDebugDisableTelemetryV2Event"] = "True",
            ["FFlagDebugDisableTelemetryPoint"] = "True",
            ["FIntVertexSmoothingGroupTolerance"] = "1",
            ["FFlagStudioDataCollectionAddBasicNotification"] = "False",
            ["DFFlagOptimizeInstanceQueries"] = "True",
            ["FFlagNewLightAttenuation"] = "True",
            ["DFIntTeleportClientAssetPreloadingHundredthsPercentage2"] = "100000",
            ["DFFlagSimRefactorCollisionGeometry2"] = "True",
            ["FFlagFRMRefactor"] = "False",
            ["FFlagDontRerenderForBadTexture"] = "True",
            ["FFlagEnablePreferredTextSizeStyleFixesInExperienceMenu"] = "True",
            ["DFIntConnectionMTUSize"] = "1200",
            ["FFlagSelfViewCameraDefaultButtonInViewPort"] = "False",
            ["FIntSelfViewTooltipLifetime"] = "0",
            ["FFlagAdServiceEnabled"] = "False",
            ["FFlagEnablePreferredTextSizeStyleFixesInAppShell4"] = "True",
            ["FFlagEnablePreferredTextSizeSettingInMenus2"] = "True",
            ["FFlagAXSearchLandingPageIXPEnabled4"] = "False",
            ["FIntUnifiedLightingBlendZone"] = "1",
            ["FFlagDebugDisableTelemetryEventIngest"] = "True",
            ["FFlagUserEnableCameraToggleNotification"] = "False",
            ["DFIntGraphicsOptimizationModeMaxFrameTimeTargetMs"] = "20",
            ["FFlagNotificationButtonTypeVariantMappingEmphasis"] = "False",
            ["FStringTerrainMaterialTable2022"] = "",
            ["FIntCAP1209DataSharingTOSVersion"] = "0",
            ["DFFlagTeleportClientAssetPreloadingDoingExperiment2"] = "True",
            ["FFlagPreferredTextSizeStyleFixEventDescriptionExperienceTile"] = "True",
            ["DFFlagTeleportClientAssetPreloadingEnabled9"] = "True",
            ["FFlagRenderShadowSkipHugeCulling"] = "True",
            ["FFlagBetaBadgeLearnMoreLinkFormview"] = "False",
            ["DFStringWebviewUrlAllowlist"] = "",
            ["FFlagContentProviderPreloadHangTelemetry"] = "False",
            ["FFlagEnablePreferredTextSizeStyleFixesInReportMenu"] = "True",
            ["DFIntHttpParallelLimit_RequestExperienceNotificationService"] = "0",
            ["FFlagEnableChromeFTUX"] = "True",
            ["DFFlagDebugSkipMeshVoxelizer"] = "True",
            ["FFlagCAP1209EnableDataSharingUI4"] = "False",
            ["FFlagCSGDecalOptimizeVB"] = "True",
            ["FFlagDebugDisableTelemetryV2Counter"] = "True",
            ["FFlagSelfViewAvoidErrorOnWrongFaceControlsParenting"] = "False",
            ["FFlagFixExitDialogBlockVRView"] = "True",
            ["FFlagWindowsReportAbuseNotification"] = "False",
            ["FIntRomarkStartWithGraphicQualityLevel"] = "2",
            ["FFlagFixParticleEmissionBias2"] = "False",
            ["FFlagUserHideCharacterParticlesInFirstPerson"] = "True",
            ["DFFlagTeleportClientAssetPreloadingDoingExperiment"] = "True",
            ["FFlagViewCollisionFadeToBlackInVR"] = "False",
            ["FIntDebugTextureManagerSkipMips"] = "2",
            ["DFIntPerformanceControlTextureQualityBestUtility"] = "-1",
            ["DFFlagPhysicsMechanismCacheOptimizeAlloc"] = "True",
            ["DFIntReportServerConnectionLostHundredthsPercent"] = "0",
            ["FFlagSimEnableDCD16"] = "True",
            ["FFlagVoiceBetaBadge"] = "False",
            ["FFlagEnableAudioPannerFiltering"] = "True",
            ["FFlagLuaAppGenreUnderConstruction"] = "False",
            ["FFlagDebugRenderingSetDeterministic"] = "True",
            ["DFFlagSimSkipVoxelCDECMerge"] = "True",
            ["DFFlagAdsPreloadInteractivityAssets"] = "True",
            ["FFlagQuaternionPoseCorrection"] = "True",
            ["FIntFixForBulkPresenceNotifications"] = "0",
            ["FFlagEnableCullableScene2OptimizeStep"] = "True",
            ["FFlagFixParticleAttachmentCulling"] = "False",
            ["FFlagEnableChildrenLockFromLua"] = "False",
            ["FFlagAXAdaptiveScrollingSnapItemEditor"] = "True",
            ["DFStringAnalyticsNS1BeaconConfig"] = "https://127.0.0.1:443/|g2hjxw|https://127.0.0.1:443/|g2g5dg|https://127.0.0.1:443/|148d53m",
            ["FFlagDebugDisableTelemetryEphemeralCounter"] = "True",
            ["FFlagEnableRemoveIsFromToastNotification"] = "False",
            ["DFFlagJointIrregularityOptimization"] = "True",
            ["DFFlagOpenCloudV1CreateUserNotificationAsync"] = "False",
            ["FFlagUserSoundsUseRelativeVelocity2"] = "True",
            ["FIntRenderLocalLightUpdatesMax"] = "1",
            ["FFlagFixEmotesMenuVR"] = "True",
            ["FFlagGraphicsGLEnableHQShadersExclusion"] = "False",
            ["FFlagDisableFeedbackSoothsayerCheck"] = "False",
            ["DFFlagAudioToggleVolumetricPanning"] = "True",
            ["DFFlagEnableExperienceNotificationOptInPrompt"] = "False",
            ["DFIntGraphicsOptimizationModeMinFrameTimeTargetMs"] = "25",
            ["FIntAXAdaptiveScrollingJustSelectedMillis"] = "2000",
            ["FFlagToastNotificationsProtocolEnabled2"] = "False",
            ["FIntNewInGameMenuPercentRollout3"] = "0",
            ["DFFlagOptimizeIsA"] = "True",
            ["DFStringAltTelegrafAddress"] = "127.0.0.1",
            ["FFlagSelfViewMoreNilChecks"] = "False",
            ["FFlagDebugGraphicsPreferD3D11"] = "True",
            ["FIntRuntimeMaxNumOfThreads"] = "2400",
            ["FFlagDebugCodegenOptSize"] = "True",
            ["FFlagUseNotificationServiceIsConnected"] = "False",
            ["DFFlagDebugOverrideDPIScale"] = "False",
            ["FIntRefreshRateLowerBound"] = "120",
            ["FIntUITextureMaxUpdateDepth"] = "-1",
            ["FFlagEnablePreferredTextSizeStyleFixesInAvatarExp"] = "True",
            ["FIntDirectionalAttenuationMaxPoints"] = "1",
            ["FFlagAXFixAdaptiveScrollingSnapAndroid"] = "True",
            ["FFlagDisableChromeV3StaticSelfView"] = "False",
            ["DFIntNumAssetsMaxToPreload"] = "2147483647",
            ["FFlagLuaAppGamesPagePreloadingDisabled"] = "False",
            ["FFlagDebugSkyGray"] = "True",
            ["FFlagUpdateHTTPCookieStorageFromWKWebView"] = "False",
            ["FFlagClientToastNotificationsEnabled"] = "False",
            ["FFlagDeveloperToastNotificationsEnabled"] = "False",
            ["FFlagRenderEnableGlobalInstancingD3D11"] = "False",
            ["DFFlagTeleportClientAssetPreloadingEnabledIXP2"] = "True",
            ["FStringInExperienceNotificationsLayer"] = "",
            ["FFlagLuauCodegen"] = "True",
            ["FFlagGraphicsTextureCopy"] = "True",
            ["FFlagEnableInGameMenuChromeABTest4"] = "False",
            ["DFFlagOptimizeNoCollisionPrimitiveInMidphaseCrash"] = "True",
            ["DFFlagEnableTexturePreloading"] = "True",
            ["FFlagVideoTextureSupportHardwareRender2"] = "True",
            ["DFFlagTeleportClientAssetPreloadingEnabledIXP"] = "True",
            ["FFlagSelfViewUpdatedCamFraming"] = "False",
            ["FFlagChatTranslationEnableSystemMessage"] = "False",
            ["DFIntCSGLevelOfDetailSwitchingDistanceL34"] = "0",
            ["FFlagMockOpenSelfViewForCameraUser"] = "False",
            ["DFIntDebugFRMQualityLevelOverride"] = "1",
            ["FFlagDebugDisableTelemetryV2Stat"] = "True",
            ["FIntFRMMinGrassDistance"] = "0",
            ["FFlagSelfViewHumanoidNilCheck"] = "False",
            ["DFIntAnimationLodFacsDistanceMax"] = "0",
            ["FFlagEnableCommandAutocomplete"] = "False",
            ["FIntPreferredTextSizeSettingBetaFeatureRolloutPercent"] = "100",
            ["FIntFriendRequestNotificationThrottle"] = "0",
            ["DFFlagTeleportPreloadingMetrics5"] = "True",
            ["FFlagPreOptimizeNoCollisionPrimitive"] = "True",
            ["FIntFRMMaxGrassDistance"] = "0",
            ["DFFlagNotificationServiceIsConnectedProperty"] = "False",
            ["FStringGraphicsDisableUnalignedDxtGPUNameBlacklist"] = "null",
            ["FFlagGraphicsGLEnableSuperHQShadersExclusion"] = "False",
            ["FIntDebugFRMOptionalMSAALevelOverride"] = "0",
            ["DFFlagOptimizeClusterCacheAlloc"] = "True",
            ["DFFlagDebugPauseVoxelizer"] = "True",
            ["FFlagDebugStudioForceSystemDeprecationNotification"] = "False",
            ["FFlagSelfViewRemoveVPFWhenClosed"] = "False",
            ["DFIntAnimationLodFacsDistanceMin"] = "0",
            ["FIntCAP1209DataSharingRolloutPercentage"] = "0",
            ["DFStringRobloxAnalyticsURL"] = "http://127.0.0.1:443/",
            ["FFlagLuaAppEnableToastNotificationsCoreScripts4"] = "False",
            ["FFlagGraphicsEnableD3D10Compute"] = "True",
            ["FFlagCoreGuiSelfViewVisibilityFixed"] = "False",
            ["FFlagEnablePreferredTextSizeStyleFixesAddFriends"] = "True",
            ["DFFlagEngineAPISendNotificationClientAnalytics"] = "False",
            ["FFlagLuaAppEnableParentalControlExperiment"] = "False",
            ["FIntStudioExternalNotificationImplMessageWriteTimeOut"] = "0",
            ["DFIntMacWebViewTelemetryThrottleHundredthsPercent"] = "0",
            ["FFlagEnableAudioEmitterDistanceAttenuation"] = "True",
            ["FFlagVRBackpackImproved"] = "True",
            ["DFIntRaknetBandwidthPingSendEveryXSeconds"] = "1",
            ["DFFlagEnableMeshPreloading2"] = "True",
            ["FFlagRenderOptimizeDecalTransparencyInvalidation"] = "True",
            ["DFIntMaxFrameBufferSize"] = "4",
            ["DFIntWindowsWebViewTelemetryThrottleHundredthsPercent"] = "0",
            ["FIntStudioWebView2TelemetryHundredthsPercent"] = "0",
            ["DFIntWaitOnUpdateNetworkLoopEndedMS"] = "100",
            ["FFlagEnablePreferredTextSizeStyleFixesInPurchasePrompt"] = "True",
            ["FFlagAXAdaptiveScrollingItemResetFix2"] = "True",
            ["FFlagDebugSSAOForce"] = "False",
            ["FFlagSelfViewFixes"] = "False",
            ["FFlagInExperienceUpsellSelfViewFix"] = "False",
            ["FFlagFixIGMTabTransitions"] = "True",
            ["FFlagEnableMenuControlsABTest"] = "False",
            ["FFlagShaderLightingRefactor"] = "True",
            ["FFlagPreloadMinimalFonts"] = "True",
            ["FFlagEnableIOSWebViewCookieSyncFix"] = "False",
            ["DFFlagVoiceChatTurnOnMuteUnmuteNotificationHack"] = "False",
            ["FFlagSelfViewTweaksPass"] = "False",
            ["FFlagSelfViewGetRidOfFalselyRenderedFaceDecal"] = "False",
            ["FFlagTopBarUseNewBadge"] = "False",
            ["FFlagFixSelfViewPopin"] = "False",
            ["FFlagUserShowGuiHideToggles"] = "True",
            ["FFlagFixReducedMotionStuckIGM2"] = "True",
            ["DFFlagWindowsWebViewTelemetryEnabled"] = "False",
            ["FFlagEnableInGameMenuChrome"] = "True",
            ["FFlagSyncWebViewCookieToEngine2"] = "False",
            ["FFlagEnablePreferredTextSizeConnection"] = "True",
            ["DFIntVoiceChatMaxRecordedDataDeliveryIntervalMs"] = "2147483647",
            ["FFlagEnableInGameMenuChromeABTest3"] = "False",
            ["FIntTerrainOTAMaxTextureSize"] = "4",
            ["FFlagAXAdaptiveScrollingImprovementIXPEnabled"] = "True",
            ["DFFlagAssetPreloadingUrlVersionEnabled2"] = "True",
            ["FFlagAssetPreloadingIXP"] = "True",
            ["DFIntRakNetResendRttMultiple"] = "1",
            ["FFlagDebugCheckRenderThreading"] = "True",
            ["FFlagSignalRNotificationManagerMaybeStart"] = "False",
            ["FFlagEnableBubbleChatFromChatService"] = "False",
            ["FIntRenderShadowmapBias"] = "-1",
            ["FFlagToastNotificationsReceivedAndDismissedSignals"] = "False",
            ["FFlagDebugGraphicsPreferVulkan"] = "True",
            ["FFlagDebugGraphicsPreferOpenGL"] = "True",
            ["FFlagDisableNewIGMinDUA"] = "True",
            ["DFIntPlayerNetworkUpdateRate"] = "60",
            ["FFlagOptimizeNetwork"] = "True",
            ["FFlagOptimizeNetworkTransport"] = "True",
            ["FFlagOptimizeNetworkRouting"] = "True",
            ["DFIntPlayerNetworkUpdateQueueSize"] = "20",
            ["DFIntNetworkLatencyTolerance"] = "1",
            ["FFlagEnableQuickGameLaunch"] = "False",
            ["DFIntNetworkPrediction"] = "120",
            ["DFIntOptimizePingThreshold"] = "50",
            ["FFlagOptimizeServerTickRate"] = "True",
            ["DFIntLargePacketQueueSizeCutoffMB"] = "1000",
            ["DFIntMaxProcessPacketsJobScaling"] = "10000",
            ["DFIntMaxProcessPacketsStepsAccumulated"] = "0",
            ["DFIntMaxProcessPacketsStepsPerCyclic"] = "5000",
            ["DFIntMegaReplicatorNetworkQualityProcessorUnit"] = "10",
            ["DFIntPhysicsReceiveNumParallelTasks"] = "20",
            ["DFIntPhysicsAnalyticsHighFrequencyIntervalSec"] = "20",
            ["FFlagSimAdaptiveMinorOptimizations"] = "True",
            ["FIntSimWorldTaskQueueParallelTasks"] = "20",
            ["FIntSmoothClusterTaskQueueMaxParallelTasks"] = "20",
        }
    },
    {
        name = "FPS Boost Potato Mode",
        desc = "Extreme performance - lowest quality settings",
        flags = {
            ["FFlagHandleAltEnterFullscreenManually"] = "False",
            ["DFIntNetMaxUDPSendPacketSize"] = "1400",
            ["FFlagDebugDisableNetworkPause"] = "true",
            ["DFIntNetPredictiveInterpolationBufferMS"] = "0",
            ["FFlagNetworkSkipInitialInterp"] = "true",
            ["DFIntNetPendingWritablesThreshold"] = "1",
            ["FFlagNetworkUpdateRate"] = "100",
            ["DFIntPhysicalObjectSendRate"] = "100",
            ["FFlagOptimizeNetwork"] = "True",
            ["FFlagUseOptimizedNetworkSignal"] = "true",
            ["DFIntNetworkDataCacheSize"] = "2048",
            ["FFlagDisablePostEffects"] = "true",
            ["FIntRenderShadowIntensity"] = "0",
            ["FFlagVisualEngineDof"] = "false",
            ["FFlagRenderGlowPath"] = "false",
            ["FFlagRenderShadowsProperty"] = "false",
            ["FFlagRenderLocalPlayerShadows"] = "false",
            ["FFlagRenderNoSkylightShadows"] = "true",
            ["FFlagRenderSimpleReflections"] = "true",
            ["FFlagRenderGrassHeight"] = "0",
            ["FIntRenderTerrainDetail"] = "0",
            ["FIntRenderTextureDetail"] = "0",
            ["FFlagRenderUseVulkan"] = "true",
            ["DFIntTaskSchedulerTargetFps"] = "9999999",
            ["FFlagSimulateInferredVsync"] = "false",
            ["FIntCameraMaxZoomDistance"] = "999999",
            ["FFlagDebugDisplayFPS"] = "True",
            ["DFFlagEnableInGameMenuInertia"] = "false",
            ["FFlagUserShowGuiHighDpi"] = "false",
            ["FFlagEnableQuickGameLaunch"] = "False",
            ["FFlagDisableVignette"] = "true",
            ["FFlagRenderForceLowQualityBloom"] = "true",
            ["FFlagRenderTextureCacheSkipPruning"] = "true",
            ["FFlagRenderFixImpreciseLightCulling"] = "true",
            ["FFlagRenderCullParticles"] = "true",
            ["FFlagRenderCullLights"] = "true",
            ["FFlagRenderHighDpiEnabled"] = "false",
            ["FFlagRenderGraphicsCheckDisable"] = "true",
            ["FFlagPreloadAllFonts"] = "True",
            ["FFlagDebugDisplayUntrackedMemory"] = "true",
            ["FFlagDebugDisplayPerfStats"] = "true",
            ["FFlagDebugEnableVoiceChatAudioResampler"] = "false",
            ["FFlagAudioEnableVoiceChat"] = "false",
            ["FFlagRenderPreloadAllTextures"] = "true",
            ["FFlagFastExit"] = "true",
            ["FFlagEnableFastPingResponse"] = "true",
            ["FFlagEnableSelectiveNetworking"] = "true",
            ["FFlagNetworkConditioning"] = "false",
            ["FFlagNetworkIgnoreCongestion"] = "true",
            ["FFlagPhysicsSkipFrame"] = "true",
            ["FFlagPhysicsSolverHighPrecision"] = "false",
            ["FFlagPhysicsGJKCollectorForceCheck"] = "false",
            ["FFlagPhysicsEnablePacketLossSimulation"] = "false",
            ["FFlagPhysicsParallelUpdate"] = "true",
            ["FFlagPhysicsOptimizeCollision"] = "true",
            ["FFlagDebugDisablePhysicsPause"] = "true",
            ["FFlagRenderTargetManagerUseFixedPool"] = "true",
            ["FFlagRenderDeformersUseGpu"] = "true",
            ["FFlagRenderEnableGlobalLightSettings"] = "false",
            ["FFlagRenderLocalLightBudget"] = "0",
            ["FFlagRenderHighQualityMaterials"] = "false",
            ["FFlagRenderUseCorrectEnvironmentMap"] = "false",
            ["FFlagRenderOpaquePassLast"] = "true",
            ["FFlagRenderEnableInstancing"] = "true",
            ["FFlagRenderBatchParticles"] = "true",
            ["FFlagRenderUseNewParticleSystem"] = "true",
            ["FFlagRenderDisableLightShadows"] = "true",
            ["FFlagRenderDisableHighlight"] = "true",
            ["FFlagRenderDisableSelectionBox"] = "true",
            ["FFlagRenderDisableBillboards"] = "false",
            ["FFlagRenderDisableDecals"] = "true",
            ["FFlagRenderDisableParticles"] = "false",
            ["FFlagRenderDisableTrails"] = "false",
            ["FFlagRenderDisableBeams"] = "false",
            ["FFlagRenderDisableRibbons"] = "false",
            ["FFlagRenderDisableSparkles"] = "true",
            ["FFlagRenderDisableSelectionHighlight"] = "true",
            ["FFlagRenderDisableSelectionGlow"] = "true",
            ["FFlagRenderDisableSelectionOutline"] = "true",
            ["FFlagRenderDisableSelectionLasso"] = "true",
            ["FFlagRenderDisableSelectionCursor"] = "false",
            ["FFlagDebugDisableImGui"] = "true",
            ["FFlagDebugDisableProfiler"] = "true",
            ["FFlagDebugDisableTelemetry"] = "true",
            ["FFlagDebugForceResetDataStores"] = "false",
            ["FFlagDebugOptimizedCheckOcclusion"] = "true",
            ["FFlagDebugUseFmodForAllAudio"] = "true",
            ["FFlagEnableAudioDevices"] = "false",
            ["FFlagEnableCaptions"] = "false",
            ["FFlagEnablePlayerShadows"] = "false",
            ["FFlagEnablePostProcessBatching"] = "true",
            ["FFlagEnableSmoothClusterPath"] = "false",
            ["FFlagEnableTerrainGlobalCulling"] = "true",
            ["FFlagEnableTextureStreaming"] = "true",
            ["FFlagForceCenterCursor"] = "true",
            ["FFlagForceHBAOOff"] = "true",
            ["FFlagForceNoneAntialiasing"] = "true",
            ["FFlagGraphicsHBAO"] = "false",
            ["FFlagHandleAltTab"] = "true",
            ["FFlagLimitAudioCacheSize"] = "true",
            ["FFlagOptimizeGuiDataStructures"] = "true",
            ["FFlagOptimizeVoiceChatBuffer"] = "true",
            ["FFlagUseNewCloudSystem"] = "false",
            ["FFlagUseNewPhysicsSolver"] = "true",
            ["FIntAntialiasingQuality"] = "0",
            ["FIntAutoHyphenationForceLimit"] = "0",
            ["FIntBackBufferCount"] = "1",
            ["FIntDebugForceOutputHardwareDetail"] = "0",
            ["FIntExtraLowMeshMemoryPrio"] = "1",
            ["FIntMeshCacheSize"] = "128",
            ["FIntRenderShadowMapResolution"] = "32",
            ["FIntRenderSkyboxResolution"] = "64",
            ["FIntScrollWheelDelta"] = "120",
            ["DFFlagRakNetUnblockSelectOnShutdownByWritingToSocket"] = "True",
            ["DFFlagRakNetCalculateApplicationFeedback2"] = "False",
            ["DFFlagDebugEnableInterpolationVisualizer"] = "True",
            ["DFFlagReplicatorCheckReadTableCollisions"] = "True",
            ["DFFlagDebugVisualizeAllPropertyChanges"] = "True",
            ["DFFlagDebugRenderForceTechnologyVoxel"] = "True",
            ["DFFlagReplicatorSeparateVarThresholds"] = "True",
            ["DFFlagRakNetDetectRecvThreadOverload"] = "True",
            ["DFFlagTextureQualityOverrideEnabled"] = "True",
            ["DFFlagRakNetDetectNetUnreachable"] = "True",
            ["DFFlagSolverStateReplicatedOnly2"] = "True",
            ["DFFlagDisableFastLogTelemetry"] = "True",
            ["DFFlagEnableTexturePreloading"] = "True",
            ["DFFlagRakNetUseSlidingWindow4"] = "True",
            ["DFFlagReplicateCreateToPlayer"] = "True",
            ["DFFlagTaskSchedulerAvoidSleep"] = "True",
            ["DFFlagDebugSkipMeshVoxelizer"] = "True",
            ["DFFlagDebugPauseVoxelizer"] = "True",
            ["DFFlagRakNetEnablePoll"] = "True",
            ["DFFlagDisableDPIScale"] = "True",
            ["DFFlagAggCpuMemRCC"] = "True",
            ["DFFlagBrowserTrackerIdTelemetryEnabled"] = "False",
            ["DFFlagGraphicsQualityUsageTelemetry"] = "False",
            ["DFFlagDebugPrintDataPingBreakDown"] = "False",
            ["DFFlagEnableFmodErrorsTelemetry"] = "False",
            ["DFFlagDebugEnableRomarkService"] = "False",
            ["DFFlagAnalyticsServiceEnabled"] = "False",
            ["DFFlagGpuVsCpuBoundTelemetry"] = "False",
            ["DFFlagNetworkUseZstdWrapper"] = "False",
            ["DFFlagAudioDeviceTelemetry"] = "False",
            ["DFFlagTrackingGcStats"] = "False",
            ["DFFlagDebugPerfMode"] = "False",
            ["FFlagEnableAnimatorSkipCopyPreviousRigKeyOnJointModification"] = "True",
            ["FFlagPreComputeAcceleratorArrayForSharingTimeCurve"] = "True",
            ["FFlagEnablePlayerViewBoundingBoxSizeDamping"] = "True",
            ["FFlagRenderEnableGlobalInstancingD3D10"] = "True",
            ["FFlagDisableOldCookieManagementSticky"] = "True",
            ["FFlagLuaAppLegacyInputSettingRefactor"] = "True",
            ["FFlagDebugDisableStudioQtErrorAssert"] = "True",
            ["FFlagEnablePerformanceControlService"] = "True",
            ["FFlagDebugDisableVideoVorbisDecoder"] = "True",
            ["FFlagDebugForceFutureIsBrightPhase3"] = "True",
            ["FFlagDebugRenderingSetDeterministic"] = "True",
            ["FFlagDebugGraphicsGLDisableDiscard"] = "True",
            ["FFlagDebugDisableOnScreenProfiler"] = "True",
            ["FFlagDebugDisableWebmAlphaSupport"] = "True",
            ["FFlagDebugDoNotLoadHumanoidSounds"] = "True",
            ["FFlagDebugForceFSMCPULightCulling"] = "True",
            ["FFlagDebugGraphicsPreferD3D11FL10"] = "True",
            ["FFlagGraphicsEnableD3D10Compute"] = "True",
            ["FFlagMessageBusCallOptimization"] = "True",
            ["FFlagPreloadTextureItemsOption4"] = "True",
            ["FFlagRenderGpuTextureCompressor"] = "True",
            ["FFlagDebugCheckRenderThreading"] = "True",
            ["FFlagDebugGraphicsPreferOpenGL"] = "True",
            ["FFlagDebugGraphicsPreferVulkan"] = "true",
            ["FFlagDebugGraphicsPreferD3D11"] = "False",
            ["FFlagReduceDirtyFlagSettings"] = "True",
            ["FFlagDebugForceGenerateHSR"] = "True",
            ["FFlagDebugGraphicsForceGL2"] = "True",
            ["FFlagHSRClusterImprovement"] = "True",
            ["FFlagFastGPULightCulling3"] = "True",
            ["FFlagDebugAvatarTracking"] = "True",
            ["FFlagDebugCodegenOptSize"] = "True",
            ["FFlagNewLightAttenuation"] = "True",
            ["FFlagSortKeyOptimization"] = "True",
            ["FFlagFasterPreciseTime4"] = "True",
            ["FFlagNewCameraControls"] = "True",
            ["FFlagReconnectDisabled"] = "True",
            ["FFlagTopBarUseNewBadge"] = "True",
            ["FFlagDisablePostFx"] = "True",
            ["FFlagDebugSkyGray"] = "True",
            ["FFlagEnableZstdDictionaryForClientSettings"] = "False",
            ["FFlagUserCameraControlLastInputTypeUpdate"] = "False",
            ["FFlagRenderLegacyShadowsQualityRefactor"] = "True",
            ["FFlagTaskSchedulerLimitTargetFpsTo2402"] = "False",
            ["FFlagChatTranslationSettingEnabled3"] = "false",
            ["FFlagGameBasicSettingsFramerateCap5"] = "false",
            ["FFlagDebugDisableOptimizedBytecode"] = "False",
            ["FFlagDebugForceModelMeshRendering"] = "False",
            ["FFlagEnableZstdForClientSettings"] = "False",
            ["FFlagDebugLightGridShowChunks"] = "False",
            ["FFlagErrorPromptResizesHeight"] = "False",
            ["FFlagKeepZeroInfluenceBones"] = "False",
            ["FFlagAdServiceEnabled"] = "False",
            ["FFlagDebugGraphics"] = "False",
            ["DFIntClientLightingTechnologyChangedTelemetryHundredthsPercent"] = "0",
            ["DFIntGraphicsOptimizationModePerformanceScalePercent"] = "10000000",
            ["DFIntPerformanceControlTextureQualityExponentTenThousandths"] = "0",
            ["DFIntRakNetApplicationFeedbackScaleUpFactorHundredthPercent"] = "0",
            ["DFIntReportRecordingDeviceInfoRateHundredthsPercentage"] = "0",
            ["DFIntRakNetApplicationFeedbackScaleUpThresholdPercent"] = "0",
            ["DFIntRaknetBandwidthInfluxHundredthsPercentageV2"] = "10000",
            ["DFIntRakNetClockDriftAdjustmentPerPingMillisecond"] = "100",
            ["DFIntReportOutputDeviceInfoRateHundredthsPercentage"] = "0",
            ["DFIntGraphicsOptimizationModeMaxFrameTimeTargetMs"] = "20",
            ["DFIntPerformanceControlTextureQualityBestUtility"] = "-1",
            ["DFIntMaxReceiveToDeserializeLatencyMilliseconds"] = "10",
            ["DFIntMegaReplicatorNetworkQualityProcessorUnit"] = "10",
            ["DFIntTrackCountryRegionAPIHundredthsPercent"] = "10000",
            ["DFIntPhysicsAnalyticsHighFrequencyIntervalSec"] = "20",
            ["DFIntPerformanceControlFrameTimeMaxUtility"] = "-1",
            ["DFIntAnimationLodFacsVisibilityDenominator"] = "0",
            ["DFIntClientPacketHealthyAllocationPercent"] = "20",
            ["DFIntNetworkInProcessLimitGameplayMsClient"] = "0",
            ["DFIntReplicationDataCacheNumParallelTasks"] = "12",
            ["DFIntCSGLevelOfDetailSwitchingDistanceL12"] = "1",
            ["DFIntCSGLevelOfDetailSwitchingDistanceL23"] = "1",
            ["DFIntCSGLevelOfDetailSwitchingDistanceL34"] = "1",
            ["DFIntInitialAccelerationLatencyMultTenths"] = "1",
            ["DFIntRaknetBandwidthPingSendEveryXSeconds"] = "1",
            ["DFIntHttpCurlConnectionCacheSize"] = "134217728",
            ["DFIntMaxProcessPacketsStepsPerCyclic"] = "5000",
            ["DFIntClientPacketMaxFrameMicroseconds"] = "200",
            ["DFIntNetworkQualityResponderMaxWaitTime"] = "1",
            ["DFIntCSGLevelOfDetailSwitchingDistance"] = "1",
            ["DFIntClientPacketExcessMicroseconds"] = "1000",
            ["DFIntMaxProcessPacketsStepsAccumulated"] = "0",
            ["DFIntTimestepArbiterThresholdCFLThou"] = "300",
            ["DFIntUserIdPlayerNameCacheSize"] = "33554432",
            ["DFIntWaitOnUpdateNetworkLoopEndedMS"] = "100",
            ["DFIntLargePacketQueueSizeCutoffMB"] = "1000",
            ["DFIntMaxProcessPacketsJobScaling"] = "10000",
            ["DFIntMegaReplicatorNumParallelTasks"] = "12",
            ["DFIntNetworkSchemaCompressionRatio"] = "0",
            ["DFIntPhysicsReceiveNumParallelTasks"] = "12",
            ["DFIntRakNetNakResendDelayRttPercent"] = "50",
            ["DFIntBatchThumbnailResultsSizeCap"] = "200",
            ["DFIntPerformanceControlFrameTimeMax"] = "4",
            ["DFIntMaxDataPacketPerSend"] = "100000",
            ["DFIntBufferCompressionThreshold"] = "100",
            ["DFIntDebugFRMQualityLevelOverride"] = "1",
            ["DFIntNetworkQualityResponderUnit"] = "10",
            ["DFIntAnimationLodFacsDistanceMax"] = "0",
            ["DFIntAnimationLodFacsDistanceMin"] = "0",
            ["DFIntRakNetNakResendDelayMsMax"] = "100",
            ["DFIntTextureCompositorActiveJobs"] = "0",
            ["DFIntWaitOnRecvFromLoopEndedMS"] = "10",
            ["DFIntCodecMaxOutgoingFrames"] = "1000",
            ["DFIntRenderingThrottleDelayInMS"] = "1",
            ["DFIntCodecMaxIncomingPackets"] = "100",
            ["DFIntConnectingTimerInterval"] = "10",
            ["DFIntDefaultTimeoutTimeMs"] = "10000",
            ["DFIntMaxAcceptableUpdateDelay"] = "1",
            ["DFIntDebugRestrictGCDistance"] = "1",
            ["DFIntRakNetResendRttMultiple"] = "1",
            ["DFIntBufferCompressionLevel"] = "0",
            ["DFIntClientPacketMaxDelayMs"] = "1",
            ["DFIntRakNetNakResendDelayMs"] = "10",
            ["DFIntTextureQualityOverride"] = "0",
            ["DFIntRakNetSelectTimeoutMs"] = "1",
            ["DFIntConnectionMTUSize"] = "900",
            ["DFIntMaxFrameBufferSize"] = "4",
            ["DFIntNetworkCluster"] = "0",
            ["DFIntLogChunkSize"] = "1",
            ["DFIntLuaGcBoost"] = "100",
            ["DFIntRakNetLoopMs"] = "1",
            ["FIntBootstrapperTelemetryReportingHundredthsPercentage"] = "0",
            ["FIntFullscreenTitleBarTriggerDelayMillis"] = "18000000",
            ["FIntInterpolationAwareTargetTimeLerpHundredth"] = "40",
            ["FIntEmotesAnimationsPerPlayerCacheSize"] = "16777216",
            ["FIntMeshContentProviderForceCacheSize"] = "268435456",
            ["FIntSmoothClusterTaskQueueMaxParallelTasks"] = "12",
            ["FIntRakNetDatagramMessageIdArrayLength"] = "1024",
            ["FIntRomarkStartWithGraphicQualityLevel"] = "1",
            ["FIntSimSolverResponsiveness"] = "2147483647",
            ["FIntRakNetResendBufferArrayLength"] = "128",
            ["FIntSimWorldTaskQueueParallelTasks"] = "20",
            ["FIntDebugTextureManagerSkipMips"] = "10",
            ["FIntInterpolationMaxDelayMSec"] = "100",
            ["FIntTerrainOTAMaxTextureSize"] = "1024",
            ["FIntRenderLocalLightUpdatesMax"] = "1",
            ["FIntRenderLocalLightUpdatesMin"] = "1",
            ["FIntDefaultMeshCacheSizeMB"] = "256",
            ["FIntRenderGrassDetailStrands"] = "0",
            ["FIntRenderLocalLightFadeInMs"] = "0",
            ["FIntRenderTextureCompositor"] = "0",
            ["FIntCSGVoxelizerFadeRadius"] = "0",
            ["FIntTaskSchedulerThreadMin"] = "3",
            ["FIntDebugForceMSAASamples"] = "1",
            ["FIntRobloxMainWindow"] = "190000",
            ["FIntTerrainArraySliceSize"] = "0",
            ["FIntFRMMaxGrassDistance"] = "0",
            ["FIntFRMMinGrassDistance"] = "0",
            ["FIntRenderShadowmapBias"] = "0",
            ["FIntTargetRefreshRate"] = "144",
            ["FIntLmsClientRollout2"] = "0",
            ["FIntModelLodDetailed"] = "-1",
            ["FIntFontSizePadding"] = "3",
            ["FIntMeshLODDetails"] = "-1",
            ["FIntRobloxTelemetry"] = "0",
            ["FIntGraphics"] = "0",
            ["SFFlagRobloxTelemetryMarketplaceDeprecatedSubscriptionFuncUseThrottleHundredthsPercent"] = "False",
            ["SFFlagRobloxTelemetryAvatarMetricsTrackSingularAssetRequestThrottleHundredthsPercent"] = "False",
            ["SFFlagPerformanceControlEventBasedTelemetryEffectPredictionEventNumReportsPerSecond"] = "False",
            ["SFFlagPerformanceControlEventBasedTelemetryTunableChangeEventNumReportsPerSecond"] = "False",
            ["SFFlagPerformanceControlEventBasedTelemetryEffectPredictionEventRateEventIngest"] = "False",
            ["SFFlagPerformanceControlEventBasedTelemetryTunableChangeEventRateEventIngest"] = "False",
            ["SFFlagRobloxTelemetrySharedStringReplicationPointsThrottleHundredthsPercent"] = "False",
            ["SFFlagPerformanceControlEventBasedTelemetryEffectPredictionEventRatePoints"] = "False",
            ["SFFlagPerformanceControlEventBasedTelemetryDefaultSamplingRateEventIngest"] = "False",
            ["SFFlagRobloxTelemetryAdTeleportPromptInteractionThrottleHundredthsPercent"] = "False",
            ["SFFlagPerformanceControlEventBasedTelemetryTunableChangeEventRatePoints"] = "False",
            ["SFFlagRobloxTelemetryRealtimeConnectionEventsThrottleHundredthsPercent"] = "False",
            ["SFFlagPerformanceControlEventBasedTelemetryDefaultSamplingRatePoints"] = "False",
            ["SFFlagRobloxTelemetryClientDisconnectEventsThrottleHundredthsPercent"] = "False",
            ["SFFlagRobloxTelemetryClientDisconnectPointsThrottleHundredthsPercent"] = "False",
            ["SFFlagPerformanceControlEventBasedTelemetryRateLimiterDefaultRegen"] = "False",
            ["SFFlagRobloxTelemetryRccDisconnectEventsThrottleHundredthsPercent"] = "False",
            ["SFFlagRobloxTelemetryRccDisconnectPointsThrottleHundredthsPercent"] = "False",
            ["SFFlagRobloxTelemetryRealtimeEventsThrottleHundredthsPercent"] = "False",
            ["SFFlagPerformanceTelemetryGlobalThrottleHundredthsPercent"] = "False",
            ["SFFlagPerformanceControlTextureQualityExponentTenThousandths"] = "0",
            ["SFFlagGraphicsOptimizationModePerformanceScalePercent"] = "100",
            ["SFFlagRobloxTelemetryBatchedReporterTimerIntervalMs"] = "False",
            ["SFFlagRobloxTelemetryStatThresholdHundredthsPercent"] = "False",
            ["SFFlagRobloxTelemetryThrottlingRenderFidelityOnTime"] = "False",
            ["SFFlagRobloxTelemetryV2PointAdatpterTrafficPercent"] = "False",
            ["SFFlagPerformanceControlTextureQualityBestUtility"] = "False",
            ["SFFlagPerformanceControlTextureQualityHardcodeWeight"] = "0",
            ["SFFlagRobloxTelemetryCreationDBPropChangesDetail"] = "False",
            ["SFFlagGraphicsOptimizationModeQualityScalePercent"] = "100",
            ["SFFlagPerformanceTelemetryReportIntervalSeconds"] = "False",
            ["SFFlagRobloxTelemetryPointV2ProdTrafficPercent"] = "False",
            ["SFFlagRobloxTelemetryCreationDBInstanceStats"] = "False",
            ["SFFlagPerformanceTelemetryQueueProcessLimit"] = "False",
            ["SFFlagRobloxTelemetryStatV2POCRandomOffset"] = "False",
            ["SFFlagRobloxTelemetryStatV2POCRandomRange"] = "False",
            ["SFFlagRolloutEnrollmentExpirationMinutes"] = "False",
            ["SFFlagPerformanceTelemetrySketchK"] = "False",
            ["SFFlagOpenXrASW"] = "True",
            ["FStringTopBarBadgeLearnMoreLink"] = "https://youtube.com/@KiwisASkid/",
            ["FStringErrorUploadToBacktraceBaseUrl"] = "http://opt-out.roblox.com",
            ["FStringIXPGraphicsOptimizationModePerformanceScale"] = "100",
            ["FStringPerformanceSendMeasurementAPISubdomain"] = "opt-out",
            ["FStringIXPGraphicsOptimizationModeQualityScale"] = "100",
            ["FStringCoreScriptBacktraceErrorUploadToken"] = "null",
            ["FStringWhitelistVerifiedUserId"] = "411955176",
            ["FStringDisableAECIxpLayer"] = "True",
            ["FStringGamesUrlPath"] = "/games/",
            ["FFlagSimOptimizeGeometryChangedAssemblies"] = "true",
            ["DFIntRagdollEarlyExitTimeTenthSecond"] = "1",
            ["FFlagFixGraphicsQuality"] = "True",
            ["DFIntHttpBatchApi_maxWaitMs"] = "40",
            ["DFIntBatchPostResultsSizeCap"] = "200",
            ["DFIntNetworkPrediction"] = "120",
            ["FFlagDebugCrashReports"] = "False",
            ["FIntRuntimeMaxNumOfConditions"] = "1000000",
            ["FFlagTweenOptimizations"] = "True",
            ["FIntCAP1544DataSharingUserRolloutPercentage"] = "0",
            ["FFlagUseDynamicSun"] = "False",
            ["DFIntSignalRHubConnectionBaseRetryTimeMs"] = "100",
            ["DFStringTelegrafHTTPTransportUrl"] = "http://opt-out.roblox.com",
            ["FFlagMouseGetPartOptimization"] = "True",
            ["FFlagNewNetworking"] = "False",
            ["DFIntHttpBatchApi_bgDelayMs"] = "1",
            ["FIntSimCSG3DCDRecomputeStrategy"] = "1",
            ["DFFlagJointIrregularityOptimization"] = "True",
            ["DFFlagOptimizePartsInPart"] = "True",
            ["DFFlagMatrixFromEulerPerf"] = "true",
            ["DFFlagSimDCDPlaneBoxFilter"] = "True",
            ["FFlagEnableTerrainFoliageOptimizations"] = "True",
            ["FIntTaskSchedulerAutoThreadLimit"] = "12",
            ["DFStringHttpPointsReporterUrl"] = "http://opt-out.roblox.com",
            ["DFIntBatchThumbnailExponentialInitialWaitMs"] = "20",
            ["DFFlagUpdateClientChannelB"] = "False",
            ["FFlagAnimatorRetargetSkipAnkleModification"] = "True",
            ["DFIntSendGameServerDataMaxLen"] = "9999999",
            ["DFIntExperienceSignalsIngestMaxEventsPerBatch"] = "500",
            ["DFFlagAllowPropertyDefaultSkip"] = "true",
            ["DFIntLightstepHTTPTransportHundredthsPercent2"] = "0",
            ["DFIntSimCSG3DCDRecomputeTotalWaitMiliSec"] = "5000",
            ["FFlagSkipJoinedSessionLog"] = "true",
            ["DFIntBatchThumbnailMinWaitMs"] = "1",
            ["DFIntSimCSG3DCDMaxNumConvexHulls"] = "500",
            ["FFlagRenderFixFog"] = "True",
            ["DFIntBatchPostExpirationTimeSeconds"] = "10",
            ["FFlagEnableNewInput"] = "True",
            ["FFlagEnableLightAttachToPart"] = "False",
            ["FFlagFixMeshPartScaling"] = "False",
            ["DFIntBatchPostRetryWaitMs"] = "50",
            ["DFIntBatchPostMaxRetries"] = "3",
            ["FFlagUseUnifiedRenderStepped"] = "False",
            ["DFIntSkipSomePropertiesPermyriad"] = "5000",
            ["DFIntSignalRCoreHandshakeTimeoutMs"] = "1000",
            ["FFlagEnableDelayedInputForSetFavorite"] = "true",
            ["FFlagShaderLightingRefactor"] = "True",
            ["FIntCAP1209DataSharingRolloutPercentage"] = "0",
            ["FFlagUserPreventOldBubbleChatOverlap"] = "False",
            ["DFStringCrashUploadToBacktraceWindowsPlayerToken"] = "null",
            ["DFIntRagdollSlowEnoughToNotTenth"] = "1",
            ["DFFlagSkipSomePropertiesSkip"] = "true",
            ["FIntActivatedCountTimerMSMouse"] = "0",
            ["FIntRuntimeMaxNumOfLatches"] = "1000000",
            ["FIntUnifiedLightingBlendZone"] = "1",
            ["FIntSmoothMouseSpringFrequencyTenths"] = "100",
            ["DFFlagOptimizeClusterCacheAlloc"] = "True",
            ["FIntGamePerfMonitorReportTimer"] = "0",
            ["DFFlagMergeFakeInputEvents3"] = "True",
            ["FFlagEnableTerrainOptimizations"] = "True",
            ["DFIntHttpBatchApi_maxReqs"] = "5",
            ["DFIntSignalRCoreHubConnectionDisconnectInfoHundredthsPercent"] = "10",
            ["FIntMockClientLightingTechnologyIxpExperimentMode"] = "0",
            ["FIntRuntimeMaxNumOfSchedulers"] = "1000000",
            ["DFIntSignalRCoreServerTimeoutMs"] = "11100",
            ["FFlagCommitToGraphicsQualityFix"] = "True",
            ["FFlagOptimizeEmotes"] = "False",
            ["FIntOptimizedContactPipelineSpatialHashOverlapToleranceMicro"] = "5000",
            ["FIntRuntimeMaxNumOfMutexes"] = "1000000",
            ["DFFlagSessionTrackingRecordHasLocation"] = "False",
            ["DFFlagFrameTimeJitterMedians2"] = "False",
            ["DFFlagDebugUpdateClientChannelA"] = "true",
            ["FFlagEnableNewHeapSnapshots"] = "False",
            ["DFIntBatchThumbnailJobRunsPerSecond"] = "500",
            ["DFStringCrashUploadToBacktraceBaseUrl"] = "http://opt-out.roblox.com",
            ["DFIntSignalRCoreHubMaxBackoffMs"] = "500",
            ["DFIntSignalRHubConnectionHeartbeatTimerRateMs"] = "1000",
            ["FFlagUseParticlesV2"] = "False",
            ["FFlagSimEnableDCD15"] = "true",
            ["DFIntSignalRCoreKeepAlivePingPeriodMs"] = "250",
            ["DFFlagEnableRequestAsyncCompression"] = "false",
            ["FIntRuntimeMaxNumOfDPCs"] = "64",
            ["DFIntNewRunningBaseAltitudeD"] = "45",
            ["DFFlagSimSkipVoxelCDECMerge"] = "True",
            ["DFIntSignalRHubConnectionConnectTimeoutMs"] = "7000",
            ["DFIntTimeBetweenSendConnectionAttemptsMS"] = "200",
            ["FFlagFixScalingModelRendering"] = "False",
            ["DFIntSignalRCoreHubBaseRetryMs"] = "50",
            ["DFFlagNextGenRepRollbackOverbudgetPackets"] = "True",
            ["DFIntRagdollDefaultTimerTenthSecond"] = "1",
            ["DFIntRemoteEventAbuseReportRateLimitMax"] = "1",
            ["DFIntBatchPostMaxWaitMs"] = "3",
            ["DFIntAnimatorThrottleMaxFramesToSkip"] = "1",
            ["DFIntThrottlingPredictionAccelerationHoldThousandth"] = "2",
            ["DFFlagSkipSomeProperties"] = "true",
            ["FFlagUseNewAnimationSystem"] = "False",
            ["FIntActivatedCountTimerMSKeyboard"] = "0",
            ["DFStringAltHttpPointsReporterUrl"] = "http://opt-out.roblox.com",
            ["DFFlagSimOptimizeSetSize"] = "True",
            ["FFlagFixSensitivityTextPrecision"] = "False",
            ["DFIntBatchThumbnailAllowedExternalTimedOutRetries"] = "1",
            ["DFFlagFrameTimeStdDev"] = "False",
            ["DFIntSignalRHeartbeatIntervalSeconds"] = "1",
            ["DFIntVisibilityCheckRayCastLimitPerFrame"] = "10",
            ["DFFlagSimCSG3DCDStats"] = "False",
            ["FIntCoordinatorPlannerStepsPerIteration"] = "8",
            ["DFIntBatchThumbnailMaxReqests"] = "3",
            ["DFStringDefaultAvatarDeathType"] = "Ragdoll",
            ["DFFlagSimDcdRecompUseClosedVoxel3"] = "False",
            ["DFIntBatchThumbnailMaxWaitMs"] = "3",
            ["DFIntJoinDataCompressionLevel"] = "0",
            ["DFStringLightstepHTTPTransportUrlPath"] = "null",
            ["DFIntSimCSG3DCDRecomputeThreashold"] = "150",
            ["DFIntBatchPostJobRunsPerSecond"] = "500",
            ["DFIntNetworkClusterPacketCacheNumParallelTasks"] = "12",
            ["DFFlagNetworkSchemaImprovements"] = "true",
            ["DFStringLightstepHTTPTransportUrlHost"] = "null",
            ["DFFlagEnableLightstepReporting2"] = "False",
            ["DFIntSignalRCoreTimerMs"] = "750",
            ["FFlagOptimizeNetworkRouting"] = "True",
            ["DFIntClusterEstimatedCompressionRatioHundredths"] = "0",
            ["DFIntBatchPostLimit"] = "128",
            ["DFIntHttpBatchApi_bgRefreshMaxDelayMs"] = "5",
            ["DFIntBatchThumbnailExperiationTimeSeconds"] = "10",
            ["FFlagSimCSG3DCDEnablePreciseCD"] = "False",
            ["FIntMockClientLightingTechnologyIxpExperimentQualityLevel"] = "7",
            ["DFIntHttpBatchApi_cacheDelayMs"] = "15",
            ["DFFlagDebugOverrideDPIScale"] = "False",
            ["DFIntBatchThumbnailMaxExponentialRetries"] = "2",
            ["FFlagPushFrameTimeToHarmony"] = "True",
            ["DFFlagSkipReadDiskCacheRedirects"] = "True",
            ["FIntRuntimeMaxNumOfSemaphores"] = "1000000",
            ["DFIntHttpBatchApi_MaxBatchesSentPerCyle"] = "10",
            ["FFlagOptimizeServerTickRate"] = "True",
            ["DFIntBatchPostMaxRequests"] = "3",
            ["DFFlagCorrectCachePolicySkipRedirectCache"] = "true",
            ["DFStringCrashUploadToBacktraceMacPlayerToken"] = "null",
            ["FFlagLatencyLogging1"] = "False",
            ["FIntLuaGcParallelMinMultiTasks"] = "12",
            ["FFlagOptimizeNetworkTransport"] = "True",
            ["FIntCAP1209DataSharingTOSVersion"] = "0",
            ["DFStringAltTelegrafHTTPTransportUrl"] = "http://opt-out.roblox.com",
            ["FFlagEnableBubbleChatFromChatService"] = "False",
            ["FStringDeathTypeValue"] = "Ragdoll",
            ["DFIntServerTickRate"] = "60",
            ["FFlagFRMRefactor"] = "False",
            ["DFIntClusterCompressionLevel"] = "0",
            ["DFStringLightstepToken"] = "null",
            ["DFIntHttpBatchApi_minWaitMs"] = "5",
            ["DFIntSignalRCoreRpcQueueSize"] = "256",
            ["FFlagEarlyUpdateBoundings"] = "true",
            ["DFFlagSimDCDEnableWithoutRollout"] = "False",
            ["DFIntSimConstraintDataCollectionRate3"] = "36420",
            ["DFFlagBaseNetworkMetrics"] = "False",
            ["DFFlagCreateMeshPartAtRuntime"] = "False",
            ["FFlagUseDeferredContext"] = "False",
            ["DFIntBatchThumbnailLimit"] = "128",
            ["FFlagActivatedCountAllInputTypes"] = "False",
            ["DFIntSimCSG3DcdMaxContacts"] = "32",
            ["DFFlagAllowRegistrationOfAnimationClipInCoreScripts"] = "True",
            ["FFlagLuaAppSystemBar"] = "False",
            ["DFIntSignalRCoreHubMaxElapsedMs"] = "5000",
            ["DFIntBatchPostMinWaitMs"] = "1",
            ["DFFlagUnifyLegacyJointGeometry"] = "True",
            ["DFIntNumFramesAllowedToBeAboveError"] = "1",
            ["DFIntJoinDataItemEstimatedCompressionRatioHundreths"] = "0",
            ["FFlagSimIslandizerManager"] = "false",
            ["DFFlagUpdateClientChannelA"] = "true",
            ["FFlagCAP1544UseNewDataSharingRollout"] = "False",
            ["FIntRuntimeMaxNumOfThreads"] = "2400",
            ["DFStringRobloxAnalyticsURL"] = "http://opt-out.roblox.com",
            ["FFlagEnableBubbleChatConfigurationV2"] = "False",
            ["DFFlagSimDcdRolloutEnableByDefault2"] = "False",
            ["DFFlagAcceleratorUpdateOnPropsAndValueTimeChange"] = "True",
            ["FIntReportDeviceInfoRollout"] = "0",
            ["FFlagUseUDPPacketPriority"] = "True",
            ["DFFlagDoNotSkipMipsBasedOnSystemMemoryPS"] = "True",
            ["DFIntDebugLimitMinTextureResolutionWhenSkipMips"] = "8",
            ["FFlagTM2SkipMipsForUnstreamable2"] = "True",
            ["S2PhysicsSenderRate"] = "250",
            ["TelemetryV2Url"] = "null",
            ["PhysicsMemoryTelemetryHundredthsPercentage"] = "0",
            ["TrackerPerfTelemetryIncludePerfData"] = "False",
            ["PerformanceControlEventBasedTelemetryEffectPredictionEventRateEventIngest"] = "0",
            ["MeshCompressionTelemetry"] = "False",
            ["RakNetMtuValue1InBytes"] = "1280",
            ["AvatarFacechatReplOverRCCTelemetryEventRateSec"] = "0",
            ["DebugAssertTelemetry"] = "False",
            ["PercentileTelemetryHundredPercent"] = "0",
            ["CLI46794SendToTelemetry"] = "False",
            ["AMPVerifiedTelemetryPointsHundredthsPercentage"] = "0",
            ["DataSenderRate"] = "4",
            ["TerrainMaterialTablePre2022"] = "",
            ["PerformanceControlEventBasedTelemetryEffectPredictionEventNumReportsPerSecond"] = "0",
            ["PercentApiRequestsRecordGoogleAnalytics"] = "0",
            ["LuauRefinementTelemetryInfluxHundredthsPercentage"] = "0",
            ["PerformanceControlEventBasedTelemetryDefaultSamplingRatePoints"] = "0",
            ["ReportOutputDeviceWithRobloxTelemetry"] = "False",
            ["AvatarFacechatLODCameraDisableTelemetryThrottleHundrethsPercent"] = "10000",
            ["EnablePerfDataGatherTelemetry2"] = "False",
            ["RenderDebugCheckThreading2"] = "True",
            ["DataSenderMaxBandwidthBps"] = "555",
            ["AppConfigurationTelemetryThrottleHundredthsPercent"] = "0",
            ["PerformanceControlMemoryCategoriesTelemetryEnabledHundrethPercentage"] = "0",
            ["TerrainMaterialTable2022"] = "",
            ["VoiceChatVolumeThousandths"] = "6000",
            ["LongAvatarAssetTelemetryThrottleHundredthsPercent"] = "0",
            ["ClientLightingTechnologyChangedTelemetryTrackTimeSpent"] = "False",
            ["KeyRingUsingDynamicConfigTelemetryInfluxHundredths"] = "0",
            ["LoadStreamAnimationFailureTelemetryHundredthsPercentage"] = "0",
            ["PerformanceControlEventBasedTelemetryEffectPredictionEventRatePoints"] = "0",
            ["CLI46794SendInputTelemetryHundredthsPercentage"] = "0",
            ["HSRClusterSymmetryDistancePercent"] = "10000",
            ["LuauRefinementTelemetryInfluxPriorityHundredthsPercentage"] = "0",
            ["PerformanceControlEventBasedTelemetryRateLimiterDefaultRegen"] = "0",
            ["AnimatorTelemetryCollectionRate"] = "0",
            ["AvatarFacechatPipelineLodTelemetryThrottleHundrethsPercent"] = "0",
            ["AMPVerifiedTelemetryHundredthsPercentage"] = "0",
            ["BrowserTrackerIdTelemetryThrottleHundredthsPercent"] = "0",
            ["AvatarChatServiceTelemetryIncludeServerFeatures"] = "False",
            ["AvatarFacechatPipelinePerformanceTelemetryThrottleHundrethsPercent"] = "0",
            ["IkControlTelemetryEventsThrottleHundrethsPercent"] = "0",
            ["AvatarFacechatReplicationOverRCCTelemetryThrottleHundrethsPercent"] = "0",
            ["KeyRingUsingDynamicConfigTelemetry"] = "False",
            ["CurveMarkerCheckerTelemetryEventsThrottleHundrethsPercent"] = "0",
            ["LuauHeapProfilerTelemetryHundredthsPercentage"] = "0",
            ["DebugDisableTelemetryAfterTest"] = "True",
            ["DebugEnableRomarkMicroprofilerTelemetry"] = "False",
            ["EnableClickToMoveUsageTelemetry2"] = "False",
            ["EnableNetworkChangeTelemtry2"] = "False",
            ["PerformanceControlEventBasedTelemetryTunableChangeEventRateEventIngest"] = "0",
            ["DataSenderMaxJoinBandwidthBps"] = "222",
            ["EnablePercentileTelemetry"] = "False",
            ["FaceAnimatorServiceTelemetryIncludeTrackerMode"] = "False",
            ["PerformanceControlEventBasedTelemetryTunableChangeEventNumReportsPerSecond"] = "0",
            ["GameNetLocalSpaceMaxSendIndex"] = "100000",
            ["RenderUseTextureManager224"] = "False",
            ["EnablePowerTraceModule"] = "True",
            ["IncludePowerSaverMode"] = "True",
            ["FFlagLuaMenuPerfImprovements"] = "True",
            ["FFlagEnableInGameMenuDurationLogger"] = "False",
            ["FFlagEnableInGameMenuModernization"] = "False",
            ["DFIntCanHideGuiGroupId"] = "32380007",
            ["FIntUITextureMaxRenderTextureSize"] = "1024",
            ["FIntRobloxGuiBlurIntensity"] = "0",
            ["SFFlagRobloxTelemetryCreationDBInstanceGUIDInvalidEvent"] = "False",
            ["SFFlagRobloxGuiBlurIntensity"] = "0",
            ["DFIntBandwidthManagerDataSenderMaxWorkCatchupMs"] = "8",
            ["FFlagSpecifyNetworkReplicatorScopeForItems"] = "True",
            ["DFIntMaxWaitTimeBeforeForcePacketProcessMS"] = "1",
            ["DFIntBandwidthManagerApplicationDefaultBps"] = "1024000",
            ["DFIntTaskSchedulerBackgroundCycleRateMs"] = "1",
            ["FIntTaskSchedulerMaxTempArenaSizeBytes"] = "2147483647",
            ["FFlagSpecifyNetworkReplicatorScope"] = "True",
            ["DFIntClientPacketMinMicroseconds"] = "1",
            ["DFIntRakNetMinAckGrowthPercent"] = "0",
            ["DFFlagHttpSslCertCacheEnabled3"] = "True",
            ["DFFlagSampleAndRefreshRakPing"] = "True",
            ["FFlagResetCacheOnLeaveGame"] = "True",
            ["DFIntMemCacheMaxCapacityMB"] = "2147483647",
            ["DFIntFileCacheReserveSize"] = "2147483647",
            ["DFFlagAlwaysSkipDiskCache"] = "False",
            ["FIntSSAO"] = "0",
            ["FLogNetwork"] = "7",
            ["FIntCLI20390_2"] = "1",
            ["FFlagLuauCodegen"] = "True",
            ["FFlagAddDMLogging"] = "False",
            ["FIntSSAOMipLevels"] = "1",
            ["DFIntSendItemLimit"] = "5",
            ["FFlagSelfViewFixes"] = "False",
            ["FIntBloomFrmCutoff"] = "-1",
            ["FIntDefaultJitterN"] = "0",
            ["FFlagDebugSSAOForce"] = "False",
            ["FFlagSimEnableDCD16"] = "True",
            ["FFlagVoiceBetaBadge"] = "False",
            ["FFlagFixEmotesMenuVR"] = "True",
            ["DFFlagUseVisBugChecks"] = "True",
            ["FFlagAddHapticsToggle"] = "False",
            ["FFlagEnableChromeFTUX"] = "True",
            ["FFlagFixSelfViewPopin"] = "False",
            ["DFIntCharacterLoadTime"] = "1",
            ["FFlagRenderCBRefactor2"] = "True",
            ["FFlagSelfieViewEnabled"] = "True",
            ["DFFlagFastEndUpdateLoop"] = "True",
            ["DFFlagLightGridSimdNew3"] = "True",
            ["DFStringTelegrafAddress"] = "127.0.0.1",
            ["FFlagAssetPreloadingIXP"] = "True",
            ["FFlagSelfViewTweaksPass"] = "False",
            ["FFlagShoeSkipRenderMesh"] = "False",
            ["FFlagTouchscreenSupport"] = "True",
            ["FFlagGraphicsTextureCopy"] = "True",
            ["FFlagPreloadMinimalFonts"] = "True",
            ["FFlagRenderNoLowFrmBloom"] = "False",
            ["FFlagAlwaysShowVRToggleV3"] = "False",
            ["FFlagEnableVisBugChecks27"] = "True",
            ["FFlagFixIGMTabTransitions"] = "True",
            ["FFlagGuiHidingApiSupport2"] = "True",
            ["FFlagLargeReplicatorRead2"] = "True",
            ["FFlagVRFixCursorJitterLua"] = "True",
            ["FIntRefreshRateLowerBound"] = "120",
            ["FStringDebugShowFlagState"] = "FIntInterpolationMaxDelayMSec, DFIntS2PhysicsSenderRate, DFIntTargetTimeDelayFacctorTenths",
            ["DFIntNumAssetsMaxToPreload"] = "2147483647",
            ["DFStringAltTelegrafAddress"] = "127.0.0.1",
            ["FFlagLargeReplicatorWrite2"] = "True",
            ["FFlagRenderFixGrassPrepass"] = "False",
            ["FFlagSelfViewMoreNilChecks"] = "False",
            ["DFFlagEnableMeshPreloading2"] = "True",
            ["DFFlagEnableSoundPreloading"] = "True",
            ["DFFlagMouseMoveOncePerFrame"] = "False",
            ["DFFlagReplicatorDisKickSize"] = "True",
            ["DFIntRakNetMtuValue2InBytes"] = "1240",
            ["DFIntRakNetMtuValue3InBytes"] = "1200",
            ["DFStringWebviewUrlAllowlist"] = "",
            ["FFlagLoginPageOptimizedPngs"] = "True",
            ["FIntSelfViewTooltipLifetime"] = "0",
            ["FIntUITextureMaxUpdateDepth"] = "-1",
            ["DFIntSendRakNetStatsInterval"] = "2147483647",
            ["FFlagFixChunkLightingUpdate2"] = "True",
            ["FFlagLargeReplicatorEnabled2"] = "True",
            ["FFlagVRMouseMoveOptimization"] = "True",
            ["FFlagVisBugChecksThreadYield"] = "True",
            ["DFFlagOptimizeInstanceQueries"] = "True",
            ["DFIntServerFramesBetweenJoins"] = "1",
            ["FFlagControlBetaBadgeWithGuac"] = "False",
            ["FFlagEnableVRFTUXExperienceV2"] = "True",
            ["FFlagFixExitDialogBlockVRView"] = "True",
            ["FFlagFixParticleEmissionBias2"] = "False",
            ["FFlagQuaternionPoseCorrection"] = "True",
            ["FFlagSelfViewHumanoidNilCheck"] = "False",
            ["FFlagCreationDBCompressRequest"] = "False",
            ["FFlagDontRerenderForBadTexture"] = "True",
            ["FFlagEnableChildrenLockFromLua"] = "False",
            ["FFlagEnableCommandAutocomplete"] = "False",
            ["FFlagFixIGMBottomBarVisibility"] = "True",
            ["FFlagFixReducedMotionStuckIGM2"] = "True",
            ["FFlagSelfViewUpdatedCamFraming"] = "False",
            ["FFlagSoundsUsePhysicalVelocity"] = "True",
            ["FFlagUserFixLoadAnimationError"] = "True",
            ["DFFlagAudioUseVolumetricPanning"] = "True",
            ["DFIntAudioOcclusionUpdateRateMs"] = "2",
            ["DFIntOcclusionFresnelEllipsoids"] = "6",
            ["FFlagDebugDisableTelemetryPoint"] = "True",
            ["FFlagDebugSelfViewPerfBenchmark"] = "False",
            ["FFlagEnableAudioPannerFiltering"] = "True",
            ["FFlagEnableChildrenLockFromLua2"] = "False",
            ["FFlagImproveShiftLockTransition"] = "True",
            ["FFlagSyncWebViewCookieToEngine2"] = "False",
            ["FFlagVRLaserPointerOptimization"] = "True",
            ["DFFlagTeleportPreloadingMetrics5"] = "True",
            ["DFIntTaskSchedulerJobInitThreads"] = "12",
            ["DFStringAnalyticsNS1BeaconConfig"] = "https://127.0.0.1:443/|g2hjxw|https://127.0.0.1:443/|g2g5dg|https://127.0.0.1:443/|148d53m",
            ["FFlagCAP1209EnableDataSharingUI4"] = "False",
            ["FFlagDebugDeterministicParticles"] = "False",
            ["FFlagDebugDisableTelemetryV2Stat"] = "True",
            ["FFlagOcclusionCullingBetaFeature"] = "True",
            ["FFlagRenderShadowSkipHugeCulling"] = "True",
            ["FFlagRenderSkipReadingShaderData"] = "False",
            ["FFlagSelfViewRemoveVPFWhenClosed"] = "False",
            ["FFlagUserBetterInertialScrolling"] = "True",
            ["DFFlagClampIncomingReplicationLag"] = "True",
            ["DFFlagHumanoidReplicateSimulated2"] = "True",
            ["DFFlagRobloxTelemetryAddDeviceRAM"] = "False",
            ["DFFlagSimDcdRecompUseClosedVoxel4"] = "True",
            ["DFIntOcclusionGainScalarNumerator"] = "2",
            ["DFIntTargetTimeDelayFacctorTenths"] = "12",
            ["FFlagDebugDisableTelemetryV2Event"] = "True",
            ["FFlagEnablePreferredTextSizeScale"] = "True",
            ["FFlagFixParticleAttachmentCulling"] = "False",
            ["FFlagLuaAppGenreUnderConstruction"] = "False",
            ["FFlagSelfViewLookUpHumanoidByType"] = "False",
            ["FFlagUseNotificationsLocalization"] = "False",
            ["FFlagViewCollisionFadeToBlackInVR"] = "False",
            ["FIntSmoothTerrainPhysicsCacheSize"] = "2147483647",
            ["FIntTextureCompositorLowResFactor"] = "4",
            ["FIntVRTouchControllerTransparency"] = "0",
            ["FIntVertexSmoothingGroupTolerance"] = "1",
            ["DFFlagAudioToggleVolumetricPanning"] = "True",
            ["DFIntInterpolationNumParallelTasks"] = "12",
            ["DFIntMemoryUtilityCurveNumSegments"] = "100",
            ["DFIntMicroProfilerDpiScaleOverride"] = "100",
            ["DFIntOcclusionShelfScalarNumerator"] = "2",
            ["DFIntTaskSchedulerJobInGameThreads"] = "12",
            ["DFIntVideoMaxNumberOfVideosPlaying"] = "0",
            ["FFlagDebugRenderCollectGpuCounters"] = "True",
            ["FFlagDisableChromeV3StaticSelfView"] = "False",
            ["FFlagEnableIOSWebViewCookieSyncFix"] = "False",
            ["FFlagEnableInGameMenuChromeABTest4"] = "True",
            ["FFlagFixOutdatedTimeScaleParticles"] = "False",
            ["FFlagInExperienceUpsellSelfViewFix"] = "False",
            ["FFlagMockOpenSelfViewForCameraUser"] = "False",
            ["FFlagNextGenReplicatorEnabledRead2"] = "True",
            ["FFlagRemoveRedundantFontPreloading"] = "True",
            ["FFlagRenderDynamicResolutionScale9"] = "True",
            ["FFlagReportGpuLimitedToPerfControl"] = "False",
            ["FIntRenderMeshOptimizeVertexBuffer"] = "1",
            ["FStringVoiceBetaBadgeLearnMoreLink"] = "null",
            ["DFFlagAdsPreloadInteractivityAssets"] = "True",
            ["DFFlagSimRefactorCollisionGeometry2"] = "True",
            ["DFFlagSimSmoothedRunningController2"] = "True",
            ["DFIntFrameRateMSToReduceTouchEvents"] = "30",
            ["DFIntHACDPointSampleDistApartTenths"] = "2147483647",
            ["DFIntSoundVelocitySmoothingNewRatio"] = "2",
            ["DFIntSoundVelocitySmoothingOldRatio"] = "5",
            ["FFlagAXSearchLandingPageIXPEnabled4"] = "False",
            ["FFlagAdaptiveScrollingFrameOnServer"] = "True",
            ["FFlagBetaBadgeLearnMoreLinkFormview"] = "False",
            ["FFlagCoreGuiSelfViewVisibilityFixed"] = "False",
            ["FFlagDebugDisableTelemetryV2Counter"] = "True",
            ["FFlagDebugForceFutureIsBrightPhase2"] = "True",
            ["FFlagDisableFeedbackSoothsayerCheck"] = "False",
            ["FFlagSquadToastNotificationsEnabled"] = "False",
            ["FFlagUserSoundsUseRelativeVelocity2"] = "True",
            ["FFlagWindowsReportAbuseNotification"] = "False",
            ["FIntDirectionalAttenuationMaxPoints"] = "1",
            ["FIntFixForBulkPresenceNotifications"] = "0",
            ["FStringGetPlayerImageDefaultTimeout"] = "1",
            ["DFFlagWindowsWebViewTelemetryEnabled"] = "False",
            ["DFIntServerBandwidthPlayerSampleRate"] = "2147483647",
            ["FFlagClientToastNotificationsEnabled"] = "False",
            ["FFlagFixSettingsHubVRBackgroundError"] = "True",
            ["FFlagRemovedRbxRenderingPreProcessor"] = "False",
            ["FFlagRenderTestEnableDistanceCulling"] = "True",
            ["FIntGrassMovementReducedMotionFactor"] = "0",
            ["DFIntDebugPerformanceControlFrameTime"] = "2",
            ["FFlagAXAdaptiveScrollingAvatarEditor2"] = "True",
            ["FFlagAXAdaptiveScrollingItemResetFix2"] = "True",
            ["FFlagDebugDisableTelemetryEventIngest"] = "True",
            ["FFlagDebugEnableDirectAudioOcclusion2"] = "True",
            ["FFlagEnableCullableScene2OptimizeStep"] = "True",
            ["FFlagLuaAppsEnableParentalControlsTab"] = "False",
            ["FIntDebugFRMOptionalMSAALevelOverride"] = "0",
            ["FIntFriendRequestNotificationThrottle"] = "0",
            ["FStringInExperienceNotificationsLayer"] = "",
            ["DFFlagEnablePerfRenderStatsCollection2"] = "false",
            ["FFlagAXAdaptiveScrollingSnapItemEditor"] = "True",
            ["FFlagAXFixAdaptiveScrollingSnapAndroid"] = "True",
            ["FFlagEnableBetterHapticsResultHandling"] = "True",
            ["FFlagEnablePreferredTextSizeConnection"] = "True",
            ["FFlagEnablePreferredTextSizeGuiService"] = "True",
            ["FFlagFixCountOfUnreadNotificationError"] = "False",
            ["FFlagLuaAppGamesPagePreloadingDisabled"] = "False",
            ["FFlagMigrateTextureManagerIsLocalAsset"] = "True",
            ["FFlagNewCameraControls_SpeedAdjustEnum"] = "False",
            ["FFlagRenderEnableGlobalInstancingD3D11"] = "False",
            ["DFFlagAssetPreloadingUrlVersionEnabled2"] = "True",
            ["DFIntAudioOcclusionMaxPiercedPrimitives"] = "6",
            ["DFIntOcclusionFresnelConsensusNumerator"] = "2",
            ["FFlagChatTranslationEnableSystemMessage"] = "False",
            ["FFlagDebugDisableTelemetryEphemeralStat"] = "True",
            ["FFlagGraphicsGLEnableHQShadersExclusion"] = "False",
            ["FFlagToastNotificationsProtocolEnabled2"] = "False",
            ["DFFlagPhysicsMechanismCacheOptimizeAlloc"] = "True",
            ["DFIntAudioOcclusionMaxNumQueriesPerFrame"] = "6",
            ["FFlagContentProviderPreloadHangTelemetry"] = "False",
            ["FFlagEnableRemoveIsFromToastNotification"] = "False",
            ["FFlagNotificationPluginSignalRReadEvents"] = "False",
            ["FFlagPreferredTextSizeSettingBetaFeature"] = "True",
            ["FFlagToastNotificationsUpdateEventParams"] = "False",
            ["FFlagVideoServiceAddHardwareCodecMetrics"] = "True",
            ["FIntEnableVisBugChecksHundredthPercent27"] = "100",
            ["DFIntMemoryUtilityCurveTotalMemoryReserve"] = "0",
            ["DFIntRakNetApplicationFeedbackMaxSpeedBPS"] = "0",
            ["FFlagAXPortraitSplitAdaptiveScrollingFix2"] = "True",
            ["FFlagAvatarChatIncludeSelfViewOnTelemetry"] = "False",
            ["FFlagEnableExperienceNotificationPrompts2"] = "False",
            ["FFlagEnablePartyVoiceOnlyForEligibleUsers"] = "False",
            ["FFlagSignalRNotificationManagerMaybeStart"] = "False",
            ["FFlagUpdateHTTPCookieStorageFromWKWebView"] = "False",
            ["FIntAXAdaptiveScrollingJustSelectedMillis"] = "2000",
            ["FIntEnableCullableScene2HundredthPercent3"] = "100",
            ["DFFlagAudioEnableVolumetricPanningForPolys"] = "True",
            ["DFFlagSimSolverOptimizeGeometricStiffness4"] = "True",
            ["DFIntPerformanceControlReportingPeriodInMs"] = "700",
            ["DFIntServerRakNetBandwidthPlayerSampleRate"] = "2147483647",
            ["FFlagDebugDisableTelemetryEphemeralCounter"] = "True",
            ["FFlagEnableAudioEmitterDistanceAttenuation"] = "True",
            ["FFlagLuaAppEnableParentalControlExperiment"] = "False",
            ["FFlagSelfViewCameraDefaultButtonInViewPort"] = "False",
            ["FFlagToastNotificationsResendDisplayOnInit"] = "False",
            ["DFFlagSimOptimizeGeometryChangedAssemblies3"] = "True",
            ["DFFlagTeleportClientAssetPreloadingEnabled9"] = "True",
            ["DFIntMemoryUtilityCurveBaseHundrethsPercent"] = "10000",
            ["FFlagEnablePreferredTextSizeSettingInMenus2"] = "True",
            ["FFlagUISUseLastFrameTimeInUpdateInputSignal"] = "True",
            ["DFFlagNotificationServiceIsConnectedProperty"] = "False",
            ["DFFlagPerformanceControlEnableMemoryProbing3"] = "True",
            ["DFIntClientNetworkInfluxHundredthsPercentage"] = "0",
            ["FFlagGraphicsGLEnableSuperHQShadersExclusion"] = "False",
            ["FIntRenderMaxShadowAtlasUsageBeforeDownscale"] = "1",
            ["FIntStudioWebView2TelemetryHundredthsPercent"] = "0",
            ["DFFlagEnableExperienceNotificationOptInPrompt"] = "False",
            ["DFFlagTeleportClientAssetPreloadingEnabledIXP"] = "True",
            ["FFlagAXAdaptiveScrollingImprovementIXPEnabled"] = "True",
            ["FFlagEnablePartyVoiceOnlyForUnfilteredThreads"] = "False",
            ["FFlagSelfViewGetRidOfFalselyRenderedFaceDecal"] = "False",
            ["FFlagStudioDataCollectionAddBasicNotification"] = "False",
            ["DFFlagEngineAPISendNotificationClientAnalytics"] = "False",
            ["DFFlagTeleportClientAssetPreloadingEnabledIXP2"] = "True",
            ["DFIntTimestepArbiterHumanoidLinearVelThreshold"] = "1",
            ["FFlagEnablePreferredTextSizeStyleFixesGameTile"] = "True",
            ["DFFlagVoiceChatTurnOnMuteUnmuteNotificationHack"] = "False",
            ["DFIntGraphicsOptimizationModeFRMFrameRateTarget"] = "1000",
            ["DFIntTimestepArbiterHumanoidTurningVelThreshold"] = "1",
            ["DFIntVoiceChatMaxRecordedDataDeliveryIntervalMs"] = "2147483647",
            ["FFlagLuaAppEnableToastNotificationsCoreScripts4"] = "False",
            ["FFlagRenderLightGridEfficientTextureAtlasUpdate"] = "True",
            ["FFlagSettingsHubIndependentBackgroundVisibility"] = "True",
            ["DFIntCullFactorPixelThresholdShadowMapLowQuality"] = "2147483647",
            ["DFIntGameNetCompressionLodByteBudgetThresholdPct"] = "0",
            ["DFIntServerBandwidthPlayerSampleRateFacsOverride"] = "2147483647",
            ["FFlagEnablePreferredTextSizeStyleFixesAddFriends"] = "True",
            ["FFlagNotificationsNoLongerRequireControllerState"] = "False",
            ["FFlagRenderOptimizeDecalTransparencyInvalidation"] = "True",
            ["DFFlagOptimizeNoCollisionPrimitiveInMidphaseCrash"] = "True",
            ["DFIntCullFactorPixelThresholdShadowMapHighQuality"] = "2147483647",
            ["DFIntGraphicsOptimizationModeMinFrameTimeTargetMs"] = "25",
            ["DFIntMacWebViewTelemetryThrottleHundredthsPercent"] = "0",
            ["FFlagEnablePreferredTextSizeStyleFixesInAppShell3"] = "True",
            ["FFlagEnablePreferredTextSizeStyleFixesInAppShell4"] = "True",
            ["FFlagEnablePreferredTextSizeStyleFixesInAvatarExp"] = "True",
            ["FFlagNewOptimizeNoCollisionPrimitiveInMidphase637"] = "True",
            ["FFlagNotificationButtonTypeVariantMappingEmphasis"] = "False",
            ["DFFlagTeleportClientAssetPreloadingDoingExperiment"] = "True",
            ["FFlagDebugNextGenReplicatorEnabledWriteCFrameColor"] = "True",
            ["FFlagDebugStudioForceSystemDeprecationNotification"] = "False",
            ["FFlagEnablePreferredTextSizeScalePerLayerCollector"] = "True",
            ["FFlagEnablePreferredTextSizeStyleFixesInReportMenu"] = "True",
            ["FFlagToastNotificationsReceivedAndDismissedSignals"] = "False",
            ["FStringGraphicsDisableUnalignedDxtGPUNameBlacklist"] = "null",
            ["DFFlagTeleportClientAssetPreloadingDoingExperiment2"] = "True",
            ["FFlagEnablePreferredTextSizeStyleFixesInCaptureMenu"] = "True",
            ["FFlagSelfViewAvoidErrorOnWrongFaceControlsParenting"] = "False",
            ["FIntV1MenuLanguageSelectionFeaturePerMillageRollout"] = "0",
            ["DFIntWindowsWebViewTelemetryThrottleHundredthsPercent"] = "0",
            ["FIntPreferredTextSizeSettingBetaFeatureRolloutPercent"] = "100",
            ["FIntStudioExternalNotificationImplMessageWriteTimeOut"] = "0",
            ["DFIntTeleportClientAssetPreloadingHundredthsPercentage"] = "100000",
            ["FFlagEnablePreferredTextSizeStyleFixesInExperienceMenu"] = "True",
            ["FFlagEnablePreferredTextSizeStyleFixesInPurchasePrompt"] = "True",
            ["DFIntTeleportClientAssetPreloadingHundredthsPercentage2"] = "100000",
            ["FFlagSimCSGV3IncrementalTriangulationStreamingCompression"] = "False",
            ["DFIntDebugAdditionalNumberOfMipsToSkipForNonAlbedoTextures"] = "0",
            ["DFIntHttpParallelLimit_RequestExperienceNotificationService"] = "0",
            ["DFIntContentProviderPreloadHangTelemetryHundredthsPercentage"] = "0",
            ["FFlagPreferredTextSizeStyleFixEventDescriptionExperienceTile"] = "True",
            ["FIntBootstrapperWebView2InstallationTelemetryHundredthPercent"] = "0",
            ["FFlagRenderInstanceClusterRetryPartInvalidationWhenMeshNotReady4"] = "False",
            ["FFlagDebugSimIntegrationStabilityTesting"] = "500",
            ["DFIntDebugSimPrimalPreconditioner"] = "100",
            ["DFFlagVoxelizerDisableTerrainSIMD"] = "True",
            ["DFIntDebugSimPrimalNewtonIts"] = "1",
            ["DFIntDebugSimPrimalPreconditionerMinExp"] = "1000",
            ["DFFlagSimHumanoidTimestepModelUpdate"] = "True",
            ["DFIntDebugSimPrimalLineSearch"] = "100",
            ["DFIntDebugSimPrimalToleranceInv"] = "10",
            ["FIntDebugSimPrimalGSLumpAlpha"] = "-2147483647",
            ["FFlagDebugSimDefaultPrimalSolver"] = "True",
            ["DFIntDebugSimPrimalWarmstartVelocity"] = "750",
            ["DFIntDebugSimPrimalWarmstartForce"] = "-285",
            ["FFlagEnableHumanoidLuaSideCaching"] = "False",
            ["FFlagAnimatePhysics"] = "False",
            ["DFIntRunningBaseOrientationP"] = "115",
            ["FStringPartTexturePackTable2022"] = "{\"foil\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"asphalt\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"basalt\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"brick\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"cobblestone\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"concrete\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"crackedlava\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"diamondplate\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"fabric\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"glacier\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"glass\":{\"ids\":[\"rbxassetid://98732842556\",\"rbxassetid://9438453972\"],\"color\":[255, 255, 255, 255]},\"granite\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"grass\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"ground\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"ice\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"leafygrass\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"limestone\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"marble\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"metal\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"mud\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"pavement\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"pebble\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"plastic\":{\"ids\":[\"\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"rock\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"corrodedmetal\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"salt\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"sand\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"sandstone\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"slate\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"snow\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"wood\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]},\"woodplanks\":{\"ids\":[\"rbxassetid://0\",\"rbxassetid://0\"],\"color\":[255, 255, 255, 255]}}",
            ["FFlagEnableMenuModernizationABTest2"] = "False",
            ["FFlagEnableMenuModernizationABTest"] = "False",
            ["DFFlagEnableHardwareTelemetry"] = "False",
            ["FFlagLuaAppExitModal2"] = "False",
            ["DFFlagQueueDataPingFromSendData"] = "True",
            ["DFIntUserIdPlayerNameLifetimeSeconds"] = "86400",
            ["DFFlagBatchAssetApiNoFallbackOnFail"] = "False",
            ["FStringCredit"] = "Potato Mode | @KiwisASkid on YT",
            ["FFlagEnableInGameMenuV3"] = "True",
            ["DFStringAnalyticsEventStreamUrlEndpoint"] = "opt-out",
            ["FStringInGameMenuChromeForcedUserIds"] = "1353919681",
            ["FFlagEnableSoundTelemetry"] = "False",
            ["FStringPartTexturePackTablePre2022"] = "{\"foil\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[238,238,238,255]},\"asphalt\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[227,227,228,234]},\"basalt\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[160,160,158,238]},\"brick\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[229,214,205,227]},\"cobblestone\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[218,219,219,243]},\"concrete\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[225,225,224,255]},\"crackedlava\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[76,79,81,156]},\"diamondplate\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[210,210,210,255]},\"fabric\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[221,221,221,255]},\"glacier\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[225,229,229,243]},\"glass\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[254,254,254,7]},\"granite\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[210,206,200,255]},\"grass\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[196,196,189,241]},\"ground\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[165,165,160,240]},\"ice\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[235,239,241,248]},\"leafygrass\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[182,178,175,234]},\"limestone\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[250,248,243,250]},\"marble\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[181,183,193,249]},\"metal\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[226,226,226,255]},\"mud\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[193,192,193,252]},\"pavement\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[218,218,219,236]},\"pebble\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[204,203,201,234]},\"plastic\":{\"ids\":[\"\",\"rbxassetid://13576561565\"],\"color\":[255,255,255,255]},\"rock\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[211,211,210,248]},\"corrodedmetal\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[206,177,163,180]},\"salt\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[249,249,249,255]},\"sand\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[218,216,210,240]},\"sandstone\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[241,234,230,246]},\"slate\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[235,234,235,254]},\"snow\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[239,240,240,255]},\"wood\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[217,209,208,255]},\"woodplanks\":{\"ids\":[\"rbxassetid://13576561565\",\"rbxassetid://13576561565\"],\"color\":[207,208,206,254]}}",
            ["DFIntGoogleAnalyticsLoadPlayerHundredth"] = "0",
            ["FIntRenderGrassHeightScaler"] = "0",
            ["FFlagInGameMenuV1FullScreenTitleBar"] = "False",
            ["FFlagGpuGeometryManager7"] = "True",
            ["DFStringRobloxAnalyticsSubDomain"] = "opt-out",
            ["DFFlagSimReportCPUInfo"] = "False",
            ["FFlagCoreGuiTypeSelfViewPresent"] = "False",
            ["FFlagDontCreatePingJob"] = "True",
            ["DFFlagDebugAnalyticsSendUserId"] = "False",
            ["FStringNote"] = "False",
            ["FFlagLuaAppExitModalDoNotShow"] = "True",
            ["FFlagAnimationClipMemCacheEnabled"] = "True",
            ["FFlagBatchAssetApi"] = "True",
            ["DFFlagEnableGCapsHardwareTelemetry"] = "False",
            ["DFIntHardwareTelemetryHundredthsPercent"] = "0",
            ["DFIntServerPhysicsUpdateRate"] = "60",
            ["DFIntOptimizePingThreshold"] = "50",
            ["DFIntPlayerNetworkUpdateQueueSize"] = "20",
            ["DFIntPlayerNetworkUpdateRate"] = "60",
            ["DFIntNetworkLatencyTolerance"] = "1",
            ["DFIntClientLightingEnvmapPlacementTelemetryHundredthsPercent"] = "100",
        }
    },
    {
        name = "Latency + Ping",
        desc = "Network optimization for reduced latency",
        flags = {
            ["DFIntRaknetBandwidthInfluxHundredthsPercentageV2"] = "10000",
            ["DFIntRakNetClockDriftAdjustmentPerPingMillisecond"] = "100",
            ["DFIntTextureQualityOverride"] = "1",
            ["FFlagOptimizeNetworkTransport"] = "True",
            ["DFIntTaskSchedulerTargetFps"] = "20000",
            ["DFIntWaitOnUpdateNetworkLoopEndedMS"] = "100",
            ["DFIntRakNetNakResendDelayMsMax"] = "100",
            ["DFIntGraphicsOptimizationModeMaxFrameTimeTargetMs"] = "20",
            ["FIntRenderShadowmapBias"] = "0",
            ["DFIntRaknetBandwidthPingSendEveryXSeconds"] = "1",
            ["FFlagDebugDisableTelemetryEphemeralCounter"] = "True",
            ["DFFlagRakNetUseSlidingWindow4"] = "True",
            ["FIntRuntimeMaxNumOfThreads"] = "2400",
            ["FFlagOptimizeServerTickRate"] = "True",
            ["FIntTerrainArraySliceSize"] = "0",
            ["FFlagEnableSceneAnalysis"] = "false",
            ["FIntDebugForceMSAASamples"] = "1",
            ["DFIntMaxFrameBufferSize"] = "4",
            ["DFIntMaxProcessPacketsStepsAccumulated"] = "0",
            ["DFFlagGpuVsCpuBoundTelemetry"] = "False",
            ["FFlagRenderGpuTextureCompressor"] = "True",
            ["FFlagDebugDisableTelemetryEphemeralStat"] = "True",
            ["FFlagLuauSolverV2"] = "True",
            ["FIntRakNetDatagramMessageIdArrayLength"] = "1024",
            ["DFFlagTextureQualityOverrideEnabled"] = "True",
            ["DFStringCrashUploadToBacktraceBaseUrl"] = "http://opt-out.roblox.com",
            ["DFIntPlayerNetworkUpdateRate"] = "60",
            ["FFlagDebugGraphicsPreferD3D11"] = "True",
            ["FFlagDebugDisableTelemetryPoint"] = "True",
            ["DFIntRakNetMtuValue3InBytes"] = "1200",
            ["FFlagTaskSchedulerLimitTargetFpsTo2402"] = "False",
            ["DFIntGraphicsOptimizationModeMinFrameTimeTargetMs"] = "25",
            ["FIntRenderGrassDetailStrands"] = "0",
            ["FFlagDisableChromeV3Icon"] = "True",
            ["DFIntCodecMaxOutgoingFrames"] = "10000",
            ["DFIntNetworkLatencyTolerance"] = "1",
            ["FFlagDisablePostFx"] = "True",
            ["FFlagOptimizeNetworkRouting"] = "True",
            ["DFIntRakNetNakResendDelayMs"] = "10",
            ["FFlagDebugDisableTelemetryV2Stat"] = "True",
            ["DFIntLargePacketQueueSizeCutoffMB"] = "1000",
            ["DFIntWaitOnRecvFromLoopEndedMS"] = "100",
            ["FFlagGraphicsFixMsaaInGuiScene"] = "True",
            ["FFlagDebugDisableTelemetryV2Counter"] = "True",
            ["DFIntNetworkPrediction"] = "120",
            ["FFlagDebugDisableTelemetryEventIngest"] = "True",
            ["FIntRakNetResendBufferArrayLength"] = "128",
            ["DFIntMegaReplicatorNetworkQualityProcessorUnit"] = "8",
            ["FIntRenderShadowIntensity"] = "0",
            ["FIntFullscreenTitleBarTriggerDelayMillis"] = "3600000",
            ["FIntFRMMinGrassDistance"] = "0",
            ["DFIntHttpCurlConnectionCacheSize"] = "134217728",
            ["DFIntServerTickRate"] = "60",
            ["DFIntMaxProcessPacketsStepsPerCyclic"] = "5000",
            ["FFlagOptimizeNetwork"] = "True",
            ["FFlagLoginPageOptimizedPngs"] = "true",
            ["DFIntMaxProcessPacketsJobScaling"] = "10000",
            ["DFIntConnectionMTUSize"] = "900",
            ["FIntTaskSchedulerAutoThreadLimit"] = "6",
            ["DFIntRakNetResendRttMultiple"] = "1",
            ["DFIntPerformanceControlTextureQualityBestUtility"] = "-1",
            ["DFIntOptimizePingThreshold"] = "50",
            ["DFIntPlayerNetworkUpdateQueueSize"] = "20",
            ["DFFlagSimSolverOptimizeLDLCache"] = "True",
            ["FFlagFastGPULightCulling3"] = "True",
            ["DFIntAMPVerifiedTelemetryPointsHundredthsPercentage"] = "0",
            ["DFIntPhysicsAnalyticsHighFrequencyIntervalSec"] = "8",
            ["FFlagDebugDisableTelemetryV2Event"] = "True",
            ["DFIntCodecMaxIncomingPackets"] = "100",
            ["DFIntS2PhysicsSenderRate"] = "38000",
            ["DFFlagDisableDPIScale"] = "True",
            ["FLogNetwork"] = "7",
            ["FFlagHandleAltEnterFullscreenManually"] = "False",
            ["FFlagDebugGraphicsPreferD3D11FL10"] = "True",
            ["DFIntPhysicsReceiveNumParallelTasks"] = "8",
            ["FFlagSimAdaptiveMinorOptimizations"] = "True",
            ["FIntSimWorldTaskQueueParallelTasks"] = "8",
            ["FIntSmoothClusterTaskQueueMaxParallelTasks"] = "8",
            ["DFIntReplicationDataCacheNumParallelTasks"] = "8",
            ["DFIntMegaReplicatorNumParallelTasks"] = "8",
            ["DFIntRuntimeTickrate"] = "165",
            ["DFIntGraphicsOptimizationModeFRMFrameRateTarget"] = "165",
        }
    },
}

local function parseFlags(text)
    text = tostring(text or "")
    local flags = {}
    local cleaned = text:gsub(",%s*}", "}"):gsub(",%s*%]", "]")
    local ok, decoded = pcall(HttpService.JSONDecode, HttpService, cleaned)
    if ok and type(decoded) == "table" then
        for k, v in pairs(decoded) do
            if type(k) == "string" then flags[k] = v end
        end
        return flags
    end
    for line in text:gmatch("[^\r\n]+") do
        local name, raw = line:match("^%s*([%w%.]+)%s*[:=]%s*(.+)$")
        if name then
            raw = raw:gsub("%s+$", "")
            if raw == "true" then flags[name] = true
            elseif raw == "false" then flags[name] = false
            else flags[name] = tonumber(raw) or raw end
        end
    end
    return flags
end

local function formatJson(flags)
    local parts = {}
    for k, v in pairs(flags) do
        local sv
        if type(v) == "string" then
            sv = string.format("%q", v)
        elseif type(v) == "boolean" then
            sv = tostring(v)
        else
            sv = tostring(v)
        end
        table.insert(parts, string.format('  "%s": %s', k, sv))
    end
    table.sort(parts)
    return "{\n" .. table.concat(parts, ",\n") .. "\n}"
end

-- Save/Load Utils
local SAVE_FILE = "Vaystrap_SavedFlags.json"
local function saveEditorData(text)
    if writefile then pcall(function() writefile(SAVE_FILE, text) end) end
end
local function loadEditorData()
    if readfile and isfile and isfile(SAVE_FILE) then
        local ok, res = pcall(function() return readfile(SAVE_FILE) end)
        if ok and res then return res end
    end
    return ""
end

-- Injection Blocker (full-screen neon bar)
local injectionBlocker = Instance.new("Frame")
injectionBlocker.Size = UDim2.new(1, 0, 1, 0)
injectionBlocker.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
injectionBlocker.BackgroundTransparency = 0.05
injectionBlocker.ZIndex = 10000
injectionBlocker.Visible = false
injectionBlocker.Active = true
injectionBlocker.Parent = gui
Instance.new("UICorner", injectionBlocker).CornerRadius = UDim.new(0, 14)

local blockerTitle = Instance.new("TextLabel")
blockerTitle.Size = UDim2.new(1, -40, 0, 38)
blockerTitle.Position = UDim2.new(0, 20, 0.5, -58)
blockerTitle.BackgroundTransparency = 1
blockerTitle.Text = "Applying FFlags..."
blockerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
blockerTitle.Font = Enum.Font.GothamBold
blockerTitle.TextSize = 18
blockerTitle.TextXAlignment = Enum.TextXAlignment.Center
blockerTitle.ZIndex = 10001
blockerTitle.Parent = injectionBlocker

local blockerProgress = Instance.new("TextLabel")
blockerProgress.Size = UDim2.new(1, -40, 0, 28)
blockerProgress.Position = UDim2.new(0, 20, 0.5, -16)
blockerProgress.BackgroundTransparency = 1
blockerProgress.Text = "0 / 0"
blockerProgress.TextColor3 = Color3.fromRGB(180, 180, 180)
blockerProgress.Font = Enum.Font.Gotham
blockerProgress.TextSize = 14
blockerProgress.TextXAlignment = Enum.TextXAlignment.Center
blockerProgress.ZIndex = 10001
blockerProgress.Parent = injectionBlocker

local neonBarBG = Instance.new("Frame")
neonBarBG.Size = UDim2.new(0.82, 0, 0, 10)
neonBarBG.Position = UDim2.new(0.09, 0, 0.5, 22)
neonBarBG.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
neonBarBG.BorderSizePixel = 0
neonBarBG.ZIndex = 10001
neonBarBG.Parent = injectionBlocker
Instance.new("UICorner", neonBarBG).CornerRadius = UDim.new(0, 5)

local neonBar = Instance.new("Frame")
neonBar.Size = UDim2.new(0, 0, 1, 0)
neonBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
neonBar.BorderSizePixel = 0
neonBar.ZIndex = 10002
neonBar.Parent = neonBarBG
Instance.new("UICorner", neonBar).CornerRadius = UDim.new(0, 5)

local neonGrad = Instance.new("UIGradient")
neonGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 100, 100)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100))
})
neonGrad.Parent = neonBar

local function setupAutoExecute()
    if type(queue_on_teleport) == "function" then
        local url = "https://raw.githubusercontent.com/vayntz/vaystrap/refs/heads/main/vayntzstrap.lua"
        local payload = 'task.wait(4) loadstring(game:HttpGet("' .. url .. '"))()'
        pcall(function() queue_on_teleport(payload) end)
    end
end
setupAutoExecute()


local RunService    = game:GetService("RunService")
local setfflag_func = (type(setfflag)  == "function" and setfflag)
                   or (type(set_fflag) == "function" and set_fflag)
                   or (type(setflag)   == "function" and setflag)
                   or nil

local activeFlags     = {}
local watchdogRunning = false
local isInjecting     = false   -- guard so watchdog never starts mid-injection

local FLAG_PREFIXES = {"FFlag","DFFlag","SFFlag","FInt","DFInt","SFInt","FString","DFString","SFString","FLog","DFLog","SFLog"}
local function changeFlagValue(name, value)
    if not name or name == "" or not setfflag_func then return false end
    
    local valStr = tostring(value)
    if valStr == "true"  then valStr = "True"  end
    if valStr == "false" then valStr = "False" end
    
    if pcall(setfflag_func, name, valStr) then return true end
    if pcall(setfflag_func, name, value) then return true end
    
    for _, p in ipairs(FLAG_PREFIXES) do
        if name:sub(1, #p):lower() == p:lower() then
            local stripped = name:sub(#p + 1)
            if pcall(setfflag_func, stripped, valStr) then return true end
            if pcall(setfflag_func, stripped, value) then return true end
            break
        end
    end
    return false
end

local function applyFlagsInBatches(flagTable, onDone)
    local total = 0
    local keys = {}
    for k, v in pairs(flagTable) do
        total = total + 1
        keys[total] = k
    end
    if total == 0 then if onDone then onDone(0, 0) end return end

    if not setfflag_func then
        toast("setfflag not supported by this executor!")
        if onDone then onDone(0, total) end
        return
    end

    isInjecting = true
    pcall(function()
        injectionBlocker.Visible   = true
        neonBar.Size               = UDim2.new(0, 0, 1, 0)
        blockerProgress.Text       = "Injecting 0/" .. total .. " FFlags"
        blockerTitle.Text          = "Applying FFlags..."
    end)
    
    task.wait(0.1)

    local applied = 0

    for i = 1, total do
        local name = keys[i]
        local val = flagTable[name]
        
        if changeFlagValue(name, val) then
            applied = applied + 1
            activeFlags[name] = val
        end
        
        if i % 10 == 0 then
            pcall(function()
                local pct = i / total
                neonBar.Size = UDim2.new(pct, 0, 1, 0)
                blockerProgress.Text = "Injecting " .. i .. "/" .. total .. " FFlags"
            end)
            task.wait()
        end
    end

    isInjecting = false
    pcall(function()
        neonBar.Size         = UDim2.new(1, 0, 1, 0)
        blockerProgress.Text = "Done - " .. applied .. "/" .. total .. " FFlags applied!"
        blockerTitle.Text    = "Done!"
    end)
    
    task.delay(1.5, function()
        pcall(function() injectionBlocker.Visible = false end)
        if onDone then onDone(applied, total) end
    end)
end

-- ── Watchdog ─────────────────────────────────────────────────────────────────
-- Runs every 3s AFTER injection completes; re-applies flags one by one via
-- Heartbeat (same safe mechanism), silently.
local function startWatchdog()
    if watchdogRunning or isInjecting then return end
    watchdogRunning = true

    -- Populate from save file if activeFlags is empty
    local cnt = 0
    for _ in pairs(activeFlags) do cnt = cnt + 1 end
    if cnt == 0 then
        local saved = loadEditorData()
        if saved ~= "" then
            local ok, res = pcall(HttpService.JSONDecode, HttpService, saved)
            if ok and type(res) == "table" then activeFlags = res end
        end
    end

    local wdList  = {}
    local wdIdx   = 0
    local wdTick  = 0
    local wdPause = 0

    local wdConn
    wdConn = RunService.Heartbeat:Connect(function()
        if not watchdogRunning then wdConn:Disconnect() return end
        if isInjecting then return end  -- pause watchdog during injection

        wdTick = wdTick + 1

        -- Rebuild flag list and reset every full cycle
        if wdIdx == 0 or wdIdx > #wdList then
            wdList = {}
            for k, v in pairs(activeFlags) do
                local s = tostring(v)
                if s == "true" then s = "True" elseif s == "false" then s = "False" end
                wdList[#wdList + 1] = {k, s, v}
            end
            wdIdx = 1
            -- Wait 3 seconds (3 × 60 = 180 ticks) before next cycle
            wdPause = wdTick + 180
        end

        if wdTick < wdPause then return end

        -- Apply one flag per 10 ticks in watchdog (faster since it's background)
        if wdTick % 10 == 0 then
            local entry = wdList[wdIdx]
            if entry then
                changeFlagValue(entry[1], entry[3])
            end
            wdIdx = wdIdx + 1
        end
    end)
end

local function stopWatchdog()
    watchdogRunning = false
end

-- Export the unloader so future executions can clean us up
getgenv().VaystrapUnload = function()
    pcall(stopWatchdog)
    cleanupOld()
end

local function rejoinGame()
    local placeId = game.PlaceId
    local jobId   = game.JobId
    pcall(setupAutoExecute)
    local ok = pcall(function() TeleportService:TeleportToPlaceInstance(placeId, jobId, player) end)
    if not ok then pcall(function() TeleportService:Teleport(placeId, player) end) end
end

-- Auto-apply saved flags on launch
task.delay(2, function()
    local saved = loadEditorData()
    if saved == "" then return end
    local ok, res = pcall(HttpService.JSONDecode, HttpService, saved)
    if not ok or type(res) ~= "table" then return end
    local cnt = 0
    for _ in pairs(res) do cnt = cnt + 1 end
    if cnt == 0 then return end
    toast("Auto-applying " .. cnt .. " saved FFlags...")
    applyFlagsInBatches(res, function(applied, tot)
        toast("Done! " .. applied .. "/" .. tot .. " applied!")
        startWatchdog()
    end)
end)

local notificationsEnabled = true
local settingsState = {
    notifications = true,
    autoRejoin = false,
    reapply = false,
    noTexture = false,
}

local mainNotifContainer
local toast

local function buildNotifContainer(parent)
    local nc = Instance.new("Frame")
    nc.Name = "NotifContainer"
    nc.Size = UDim2.fromOffset(260, 300)
    nc.AnchorPoint = Vector2.new(1, 1)
    nc.Position = UDim2.new(1, -10, 1, -10)
    nc.BackgroundTransparency = 1
    nc.ZIndex = 9800
    nc.ClipsDescendants = false
    nc.Parent = parent

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = nc

    return nc
end

toast = function(text, kind)
    if not settingsState.notifications then return end
    local nc = mainNotifContainer
    if not nc or not nc.Parent then return end

    local t = Instance.new("CanvasGroup")
    t.Size = UDim2.fromOffset(260, 0)
    t.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    t.GroupTransparency = 1
    t.BorderSizePixel = 0
    t.ZIndex = 9900
    t.Parent = nc
    rounded(t, 8)
    stroke(t, Color3.fromRGB(40, 40, 40), 1, 0)

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.fromOffset(26, 26)
    icon.Position = UDim2.new(0, 12, 0.5, -13)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://136293924276809"
    icon.ScaleType = Enum.ScaleType.Fit
    icon.ZIndex = 9901
    icon.Parent = t

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -54, 0, 14)
    lbl.Position = UDim2.new(0, 46, 0, 10)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Vaystrap"
    lbl.TextColor3 = C.white
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.ZIndex = 9901
    lbl.Parent = t

    local sublbl = Instance.new("TextLabel")
    sublbl.Size = UDim2.new(1, -54, 0, 14)
    sublbl.Position = UDim2.new(0, 46, 0, 26)
    sublbl.BackgroundTransparency = 1
    sublbl.Text = text
    sublbl.TextColor3 = C.muted
    sublbl.TextXAlignment = Enum.TextXAlignment.Left
    sublbl.Font = Enum.Font.Gotham
    sublbl.TextSize = 11
    sublbl.TextTruncate = Enum.TextTruncate.AtEnd
    sublbl.ZIndex = 9901
    sublbl.Parent = t

    TweenService:Create(t, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(260, 48),
        GroupTransparency = 0
    }):Play()

    task.delay(3.5, function()
        if not t.Parent then return end
        TweenService:Create(t, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(260, 0),
            GroupTransparency = 1
        }):Play()
        task.wait(0.32)
        pcall(function() t:Destroy() end)
    end)
end

local frame = Instance.new("Frame")
frame.Name = "VaystrapWindow"
frame.Size = UDim2.new(1, 0, 1, 0) 
frame.Position =  UDim2.new(0, 0, 0, 0)
frame.BackgroundColor3 = C.bg
frame.BorderSizePixel = 0
frame.ClipsDescendants = false
frame.Visible = false
frame.ZIndex = 100
frame.Parent = gui
rounded(frame, 14)
stroke(frame, C.border, 1, 0)

local frameClip = Instance.new("CanvasGroup")
frameClip.Size = UDim2.new(1, 0, 1, 0)
frameClip.BackgroundTransparency = 1
frameClip.ZIndex = 100
frameClip.Parent = frame
rounded(frameClip, 14)

local function buildNotifContainer(parent)
    local nc = Instance.new("Frame")
    nc.Size = UDim2.new(0, 260, 1, -100)
    nc.Position = UDim2.new(1, -270, 0, 50)
    nc.BackgroundTransparency = 1
    nc.ZIndex = 9800
    nc.ClipsDescendants = false
    nc.Parent = parent

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = nc

    return nc
end

mainNotifContainer = buildNotifContainer(gui)

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, HEADER_H)
header.BackgroundColor3 = C.surface
header.BorderSizePixel = 0
header.ZIndex = 200
header.Parent = frameClip
rounded(header, 14)

local headerBottom = Instance.new("Frame")
headerBottom.Size = UDim2.new(1, 0, 0, 14)
headerBottom.Position = UDim2.new(0, 0, 1, -14)
headerBottom.BackgroundColor3 = C.surface
headerBottom.BorderSizePixel = 0
headerBottom.ZIndex = 200
headerBottom.Parent = header

local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.Position = UDim2.new(0, 0, 1, 0)
headerLine.BackgroundColor3 = C.border
headerLine.BorderSizePixel = 0
headerLine.ZIndex = 201
headerLine.Parent = header

local logoHolder = Instance.new("Frame")
logoHolder.Size = UDim2.fromOffset(28, 28)
logoHolder.Position = UDim2.new(0, 12, 0.5, -14)
logoHolder.BackgroundTransparency = 1
logoHolder.ZIndex = 210
logoHolder.Parent = header

local logoLabel = Instance.new("ImageLabel")
logoLabel.Size = UDim2.new(1, 0, 1, 0)
logoLabel.BackgroundTransparency = 1
logoLabel.Image = "rbxassetid://136293924276809"
logoLabel.ScaleType = Enum.ScaleType.Fit
logoLabel.ZIndex = 210
logoLabel.Parent = logoHolder

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 150, 1, 0)
title.Position = UDim2.new(0, 52, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Vaystrap Mobile"
title.TextColor3 = C.white
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.ZIndex = 210
title.Parent = header

local function makeWindowBtn(symbol, xOff, hoverCol)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(28, 28)
    b.Position = UDim2.new(1, xOff, 0.5, -14)
    b.BackgroundColor3 = C.surface2
    b.Text = symbol
    b.TextColor3 = C.white
    b.TextSize = 16
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.ZIndex = 200
    b.Parent = header
    rounded(b, 6)
    btnFx(b, hoverCol)
    return b
end

local closeBtn = makeWindowBtn("X", -42, Color3.fromRGB(220, 40, 40))
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
local maximizeBtn = makeWindowBtn("[ ]", -76, Color3.fromRGB(70, 70, 70))
maximizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
local minimizeBtn = makeWindowBtn("-", -110, Color3.fromRGB(70, 70, 70))
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

dragWindow(frame, header)

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -HEADER_H)
sidebar.Position = UDim2.new(0, 0, 0, HEADER_H)
sidebar.BackgroundColor3 = C.surface
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 150
sidebar.Parent = frameClip
rounded(sidebar, 14)

local sidebarSquareFix = Instance.new("Frame")
sidebarSquareFix.Size = UDim2.new(1, 0, 0, 14)
sidebarSquareFix.Position = UDim2.new(0, 0, 0, 0)
sidebarSquareFix.BackgroundColor3 = C.surface
sidebarSquareFix.BorderSizePixel = 0
sidebarSquareFix.ZIndex = 149
sidebarSquareFix.Parent = sidebar

local sidebarSquareFixR = Instance.new("Frame")
sidebarSquareFixR.Size = UDim2.new(0, 14, 1, 0)
sidebarSquareFixR.Position = UDim2.new(1, -14, 0, 0)
sidebarSquareFixR.BackgroundColor3 = C.surface
sidebarSquareFixR.BorderSizePixel = 0
sidebarSquareFixR.ZIndex = 149
sidebarSquareFixR.Parent = sidebar

local sidebarLine = Instance.new("Frame")
sidebarLine.Size = UDim2.new(0, 1, 1, 0)
sidebarLine.Position = UDim2.new(1, 0, 0, 0)
sidebarLine.BackgroundColor3 = C.border
sidebarLine.BorderSizePixel = 0
sidebarLine.ZIndex = 151
sidebarLine.Parent = sidebar

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -SIDEBAR_W, 1, -HEADER_H)
contentArea.Position = UDim2.new(0, SIDEBAR_W, 0, HEADER_H)
contentArea.BackgroundTransparency = 1
contentArea.ClipsDescendants = true
contentArea.ZIndex = 140
contentArea.Parent = frameClip

local sections = {}
local sidebarBtns = {}
local activeSection = nil

local NAV_ITEMS = {
    { id = "editor",   icon = "🚩",  tip = "FFlag Editor"   },
    { id = "presets",  icon = "🔩",  tip = "Presets"        },
    { id = "settings", icon = "⚙️",  tip = "Settings"       },
    { id = "about",    icon = "ℹ️",  tip = "About"          },
}

local function makeSection(id)
    local f = Instance.new("CanvasGroup")
    f.Name = "Section_" .. id
    f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.Visible = false
    f.ZIndex = 141
    f.Parent = contentArea
    sections[id] = f
    return f
end

local function switchSection(id)
    if activeSection == id then return end
    local old = activeSection
    activeSection = id

    for _, nav in ipairs(NAV_ITEMS) do
        local btn = sidebarBtns[nav.id]
        if btn then
            local ico = btn:FindFirstChildOfClass("TextLabel")
            if nav.id == id then
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}):Play()
                if ico then TweenService:Create(ico, TweenInfo.new(0.15), {TextColor3 = C.white}):Play() end
            else
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.surface}):Play()
                if ico then TweenService:Create(ico, TweenInfo.new(0.15), {TextColor3 = C.dim}):Play() end
            end
        end
    end

    -- Hide old section instantly so it never bleeds through
    if old and sections[old] then
        local oldSec = sections[old]
        oldSec.Visible = false
        oldSec.GroupTransparency = 0
        oldSec.Position = UDim2.new(0, 0, 0, 0)
    end

    -- Animate new section in from slightly below
    local newSec = sections[id]
    if newSec then
        newSec.GroupTransparency = 1
        newSec.Position = UDim2.new(0, 0, 0.07, 0)
        newSec.Visible = true
        TweenService:Create(newSec, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            GroupTransparency = 0,
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
    end
end

for i, nav in ipairs(NAV_ITEMS) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(36, 36)
    btn.Position = UDim2.new(0, 8, 0, 14 + (i - 1) * 44)
    btn.BackgroundColor3 = C.surface
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.ZIndex = 155
    btn.Parent = sidebar
    rounded(btn, 8)

    local ico = Instance.new("TextLabel")
    ico.Size = UDim2.new(1, 0, 1, 0)
    ico.BackgroundTransparency = 1
    ico.Text = nav.icon
    ico.TextColor3 = C.dim
    ico.Font = Enum.Font.GothamBold
    ico.TextSize = 16
    ico.ZIndex = 156
    ico.Parent = btn

    btn.MouseEnter:Connect(function()
        if activeSection ~= nav.id then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(24, 24, 24)}):Play()
            TweenService:Create(ico, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeSection ~= nav.id then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.surface}):Play()
            TweenService:Create(ico, TweenInfo.new(0.15), {TextColor3 = C.dim}):Play()
        end
    end)
    btn.MouseButton1Click:Connect(function()
        switchSection(nav.id)
    end)

    sidebarBtns[nav.id] = btn
    makeSection(nav.id)
end

local function sectionLabel(parent, text, yOff)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -PAD * 2, 0, 12)
    l.Position = UDim2.new(0, PAD, 0, yOff)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = C.dim
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.GothamBold
    l.TextSize = 13
    l.ZIndex = 145
    l.Parent = parent
    return l
end

local editorSection = sections["editor"]
local editorW = WIN_W - SIDEBAR_W
local editorBoxH = WIN_H - HEADER_H - 120

sectionLabel(editorSection, "EDIT FFLAGS", PAD)

local editorFrame = Instance.new("Frame")
editorFrame.Size = UDim2.new(1, -PAD * 2, 1, -70)  -- Leave 70px for buttons
editorFrame.Position = UDim2.new(0, PAD, 0, 26)
editorFrame.BackgroundColor3 = C.surface2
editorFrame.BorderSizePixel = 0
editorFrame.ZIndex = 142
editorFrame.Parent = editorSection
rounded(editorFrame, 8)
stroke(editorFrame, C.border, 1, 0)

local editorScroll = Instance.new("ScrollingFrame")
editorScroll.Size = UDim2.new(1, -8, 1, -8)
editorScroll.Position = UDim2.new(0, 4, 0, 4)
editorScroll.BackgroundTransparency = 1
editorScroll.BorderSizePixel = 0
editorScroll.ScrollBarThickness = 4
editorScroll.ScrollBarImageColor3 = C.border
editorScroll.ZIndex = 143
editorScroll.Parent = editorFrame

local editorBox = Instance.new("TextBox")
editorBox.Size = UDim2.new(1, 0, 1, 0)
editorBox.BackgroundTransparency = 1
editorBox.Text = "{\n\n}"
editorBox.TextColor3 = C.white
editorBox.TextXAlignment = Enum.TextXAlignment.Left
editorBox.TextYAlignment = Enum.TextYAlignment.Top
editorBox.Font = Enum.Font.Code
editorBox.TextSize = 14
editorBox.ClearTextOnFocus = false
editorBox.MultiLine = true
editorBox.ZIndex = 144
editorBox.Parent = editorScroll

editorBox:GetPropertyChangedSignal("TextBounds"):Connect(function()
    editorScroll.CanvasSize = UDim2.new(0, 0, 0, editorBox.TextBounds.Y + 20)
    editorBox.Size = UDim2.new(1, 0, 0, editorBox.TextBounds.Y + 20)
end)

local function actionBtn(parent, text, sym, x, y, w, h, primary)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(w, h)
    b.Position = UDim2.fromOffset(x, y)
    b.BackgroundColor3 = primary and C.white or C.surface2
    b.Text = ""
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.ZIndex = 145
    b.Parent = parent
    rounded(b, 8)
    if not primary then
        stroke(b, C.border, 1, 0)
        btnFx(b, Color3.fromRGB(32, 32, 32))
    else
        btnFx(b, Color3.fromRGB(200, 200, 200), Color3.fromRGB(160, 160, 160))
    end

    local ic = Instance.new("TextLabel")
    ic.Size = UDim2.fromOffset(18, 18)
    ic.Position = UDim2.new(0, 12, 0.5, -9)
    ic.BackgroundTransparency = 1
    ic.Text = sym
    ic.TextColor3 = primary and C.bg or C.white
    ic.Font = Enum.Font.GothamBold
    ic.TextSize = 14
    ic.ZIndex = 146
    ic.Parent = b

    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1, -38, 1, 0)
    tl.Position = UDim2.new(0, 34, 0, 0)
    tl.BackgroundTransparency = 1
    tl.Text = text
    tl.TextColor3 = primary and C.bg or C.white
    tl.TextXAlignment = Enum.TextXAlignment.Left
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 14
    tl.ZIndex = 146
    tl.Parent = b

    return b, tl
end

local btnAreaY = editorBoxH + 34  -- Position below editor
local btnW = math.floor((editorW - PAD * 5) / 4)

local applyBtn, _ = actionBtn(editorSection, "Apply", "▶️", PAD, btnAreaY, btnW, 42, true)
local pasteBtn, _ = actionBtn(editorSection, "Paste", "📋", PAD + btnW + PAD, btnAreaY, btnW, 42, false)
local clearBtn, _ = actionBtn(editorSection, "Clear", "🗑️", PAD + btnW * 2 + PAD * 2, btnAreaY, btnW, 42, false)
local rejoinBtn, _ = actionBtn(editorSection, "Rejoin", "🔄", PAD + btnW * 3 + PAD * 3, btnAreaY, btnW, 42, false)

clearBtn.MouseButton1Click:Connect(function()
    editorBox.Text = ""
    toast("Editor cleared")
end)

applyBtn.MouseButton1Click:Connect(function()
    local flags = parseFlags(editorBox.Text)
    local total = 0
    for _ in pairs(flags) do total = total + 1 end
    if total == 0 then
        toast("No FFlags to apply - paste or type flags first")
        return
    end

    -- Lock button while injecting
    applyBtn.Active = false
    applyBtn.AutoButtonColor = false
    applyBtn.BackgroundColor3 = Color3.fromRGB(180, 180, 180) -- Lighter gray so black text is visible

    toast("Injecting " .. total .. " FFlags...")

    applyFlagsInBatches(flags,
        -- onDone
        function(applied, tot)
            toast("Done - " .. applied .. "/" .. tot .. " FFlags applied!")
            -- Unlock button
            applyBtn.Active = true
            applyBtn.BackgroundColor3 = C.white
            startWatchdog()  -- begin 3s watchdog to re-apply if Roblox resets flags
            if settingsState.autoRejoin then
                task.delay(1, rejoinGame)
            end
        end
    )
end)


pasteBtn.MouseButton1Click:Connect(function()
    local cb = ""
    if type(toclipboard) == "function" and type(getclipboard) == "function" then
        local ok, res = pcall(getclipboard)
        if ok and type(res) == "string" then cb = res end
    end
    if cb ~= "" then
        editorBox.Text = cb
        saveEditorData(cb)
        toast("Pasted from clipboard!")
    else
        toast("Clipboard empty or getclipboard not supported!")
    end
end)

rejoinBtn.MouseButton1Click:Connect(function()
    toast("Rejoining server...")
    task.delay(0.5, rejoinGame)
end)

local presetsSection = sections["presets"]

sectionLabel(presetsSection, "PRESETS", PAD)

local presetsScroll = Instance.new("ScrollingFrame")
presetsScroll.Size = UDim2.new(1, -PAD * 2, 1, -30)
presetsScroll.Position = UDim2.new(0, PAD, 0, 24)
presetsScroll.BackgroundTransparency = 1
presetsScroll.BorderSizePixel = 0
presetsScroll.ScrollBarThickness = 4
presetsScroll.ScrollBarImageColor3 = C.border
presetsScroll.ZIndex = 143
presetsScroll.Parent = presetsSection

local presetsLayout = Instance.new("UIListLayout")
presetsLayout.FillDirection = Enum.FillDirection.Vertical
presetsLayout.SortOrder = Enum.SortOrder.LayoutOrder
presetsLayout.Padding = UDim.new(0, 10)
presetsLayout.Parent = presetsScroll

local presetsPad = Instance.new("UIPadding")
presetsPad.PaddingTop = UDim.new(0, 4)
presetsPad.PaddingBottom = UDim.new(0, 4)
presetsPad.Parent = presetsScroll

local previewModal = Instance.new("Frame")
previewModal.Name = "PreviewModal"
previewModal.Size = UDim2.new(1, -30, 1, -30)
previewModal.Position = UDim2.new(0, 15, 0, 15)
previewModal.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
previewModal.BorderSizePixel = 0
previewModal.ZIndex = 9000
previewModal.Visible = false
previewModal.Parent = contentArea
rounded(previewModal, 12)
stroke(previewModal, C.border, 1, 0)

local previewClose = Instance.new("TextButton")
previewClose.Size = UDim2.fromOffset(28, 28)
previewClose.Position = UDim2.new(1, -36, 0, 8)
previewClose.BackgroundColor3 = C.surface2
previewClose.Text = "❌"
previewClose.TextColor3 = C.white
previewClose.Font = Enum.Font.GothamBold
previewClose.TextSize = 14
previewClose.AutoButtonColor = false
previewClose.BorderSizePixel = 0
previewClose.ZIndex = 9001
previewClose.Parent = previewModal
rounded(previewClose, 7)
btnFx(previewClose, Color3.fromRGB(220, 40, 40))

previewClose.MouseButton1Click:Connect(function()
    TweenService:Create(previewModal, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(1, -60, 1, -60),
        Position = UDim2.new(0, 30, 0, 30),
        BackgroundTransparency = 1
    }):Play()
    task.delay(0.2, function()
        previewModal.Visible = false
        previewModal.BackgroundTransparency = 0
    end)
end)

local previewTitle = Instance.new("TextLabel")
previewTitle.Size = UDim2.new(1, -60, 0, 28)
previewTitle.Position = UDim2.new(0, 14, 0, 10)
previewTitle.BackgroundTransparency = 1
previewTitle.Text = "Preview"
previewTitle.TextColor3 = C.white
previewTitle.TextXAlignment = Enum.TextXAlignment.Left
previewTitle.Font = Enum.Font.GothamBold
previewTitle.TextSize = 18
previewTitle.ZIndex = 9001
previewTitle.Parent = previewModal

local previewScroll = Instance.new("ScrollingFrame")
previewScroll.Size = UDim2.new(1, -14, 1, -50)
previewScroll.Position = UDim2.new(0, 7, 0, 44)
previewScroll.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
previewScroll.BorderSizePixel = 0
previewScroll.ScrollBarThickness = 4
previewScroll.ScrollBarImageColor3 = C.border
previewScroll.ZIndex = 9001
previewScroll.Parent = previewModal
rounded(previewScroll, 8)

local previewText = Instance.new("TextLabel")
previewText.Size = UDim2.new(1, -16, 0, 9999)
previewText.Position = UDim2.new(0, 8, 0, 6)
previewText.BackgroundTransparency = 1
previewText.Text = ""
previewText.TextColor3 = Color3.fromRGB(190, 190, 190)
previewText.TextXAlignment = Enum.TextXAlignment.Left
previewText.TextYAlignment = Enum.TextYAlignment.Top
previewText.Font = Enum.Font.Code
previewText.TextSize = 18
previewText.TextWrapped = true
previewText.RichText = false
previewText.ZIndex = 9002
previewText.Parent = previewScroll

local function openPreview(preset)
    previewTitle.Text = preset.name .. " - Preview"
    local json = formatJson(preset.flags)
    previewText.Text = json
    local lines = select(2, json:gsub("\n", "\n")) + 1
    previewText.Size = UDim2.new(1, -16, 0, math.max(lines * 13, 100))
    previewScroll.CanvasSize = UDim2.new(0, 0, 0, math.max(lines * 13 + 16, 100))

    previewModal.Visible = true
    previewModal.Size = UDim2.new(1, -60, 1, -60)
    previewModal.Position = UDim2.new(0, 30, 0, 30)
    previewModal.BackgroundTransparency = 1
    TweenService:Create(previewModal, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, -30, 1, -30),
        Position = UDim2.new(0, 15, 0, 15),
        BackgroundTransparency = 0
    }):Play()
end

local totalCardH = 0
for pidx, preset in ipairs(PRESETS) do
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 96)
    card.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    card.BorderSizePixel = 0
    card.ZIndex = 144
    card.LayoutOrder = pidx
    card.Parent = presetsScroll
    rounded(card, 12)
    
    local uig = Instance.new("UIGradient")
    uig.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
    })
    uig.Rotation = 45
    uig.Parent = card

    local cardName = Instance.new("TextLabel")
    cardName.Size = UDim2.new(1, -100, 0, 20)
    cardName.Position = UDim2.new(0, 14, 0, 12)
    cardName.BackgroundTransparency = 1
    cardName.Text = preset.name
    cardName.TextColor3 = C.white
    cardName.TextXAlignment = Enum.TextXAlignment.Left
    cardName.Font = Enum.Font.GothamBold
    cardName.TextSize = 14
    cardName.ZIndex = 145
    cardName.Parent = card

    local flagCount = 0
    for _ in pairs(preset.flags) do flagCount = flagCount + 1 end

    local cardCount = Instance.new("TextLabel")
    cardCount.Size = UDim2.new(0, 80, 0, 14)
    cardCount.Position = UDim2.new(1, -88, 0, 14)
    cardCount.BackgroundTransparency = 1
    cardCount.Text = flagCount .. " flags"
    cardCount.TextColor3 = C.dim
    cardCount.TextXAlignment = Enum.TextXAlignment.Right
    cardCount.Font = Enum.Font.Gotham
    cardCount.TextSize = 12
    cardCount.ZIndex = 145
    cardCount.Parent = card

    local cardDesc = Instance.new("TextLabel")
    cardDesc.Size = UDim2.new(1, -16, 0, 14)
    cardDesc.Position = UDim2.new(0, 14, 0, 34)
    cardDesc.BackgroundTransparency = 1
    cardDesc.Text = preset.desc
    cardDesc.TextColor3 = C.dim
    cardDesc.TextXAlignment = Enum.TextXAlignment.Left
    cardDesc.Font = Enum.Font.Gotham
    cardDesc.TextSize = 12
    cardDesc.ZIndex = 145
    cardDesc.Parent = card

    local addPresetBtn = Instance.new("TextButton")
    addPresetBtn.Size = UDim2.fromOffset(70, 28)
    addPresetBtn.Position = UDim2.new(1, -76, 0, 56)
    addPresetBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    addPresetBtn.Text = "+ Add"
    addPresetBtn.TextColor3 = Color3.fromRGB(10, 10, 10)
    addPresetBtn.Font = Enum.Font.GothamBold
    addPresetBtn.TextSize = 14
    addPresetBtn.AutoButtonColor = false
    addPresetBtn.BorderSizePixel = 0
    addPresetBtn.ZIndex = 146
    addPresetBtn.Parent = card
    rounded(addPresetBtn, 7)
    btnFx(addPresetBtn, Color3.fromRGB(190, 190, 190), Color3.fromRGB(160, 160, 160))

    local previewBtn = Instance.new("TextButton")
    previewBtn.Size = UDim2.fromOffset(68, 28)
    previewBtn.Position = UDim2.new(1, -150, 0, 56)
    previewBtn.BackgroundColor3 = C.surface2
    previewBtn.Text = "Preview"
    previewBtn.TextColor3 = C.white
    previewBtn.Font = Enum.Font.GothamMedium
    previewBtn.TextSize = 14
    previewBtn.AutoButtonColor = false
    previewBtn.BorderSizePixel = 0
    previewBtn.ZIndex = 146
    previewBtn.Parent = card
    rounded(previewBtn, 7)
    stroke(previewBtn, C.border, 1, 0)
    btnFx(previewBtn, Color3.fromRGB(32, 32, 32))

    local pdata = preset
    addPresetBtn.MouseButton1Click:Connect(function()
        local current = editorBox.Text
        local flags = parseFlags(current)
        for k, v in pairs(pdata.flags) do
            flags[k] = v
        end
        editorBox.Text = formatJson(flags)
        toast(pdata.name .. " added to editor")
        switchSection("editor")
    end)

    previewBtn.MouseButton1Click:Connect(function()
        openPreview(pdata)
    end)

    totalCardH = totalCardH + 82 + 10
end

presetsScroll.CanvasSize = UDim2.new(0, 0, 0, totalCardH + 8)

local settingsSection = sections["settings"]

sectionLabel(settingsSection, "SETTINGS", PAD)

local settingsScroll = Instance.new("ScrollingFrame")
settingsScroll.Size = UDim2.new(1, -PAD * 2, 1, -30)
settingsScroll.Position = UDim2.new(0, PAD, 0, 24)
settingsScroll.BackgroundTransparency = 1
settingsScroll.BorderSizePixel = 0
settingsScroll.ScrollBarThickness = 4
settingsScroll.ScrollBarImageColor3 = C.border
settingsScroll.ZIndex = 143
settingsScroll.Parent = settingsSection

local settingsLayout = Instance.new("UIListLayout")
settingsLayout.FillDirection = Enum.FillDirection.Vertical
settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
settingsLayout.Padding = UDim.new(0, 8)
settingsLayout.Parent = settingsScroll

local settingsPad = Instance.new("UIPadding")
settingsPad.PaddingTop = UDim.new(0, 4)
settingsPad.PaddingBottom = UDim.new(0, 4)
settingsPad.Parent = settingsScroll

local function makeToggleRow(parent, labelText, descText, defaultVal, order, onChanged)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 68)
    row.BackgroundColor3 = C.surface
    row.BorderSizePixel = 0
    row.ZIndex = 144
    row.LayoutOrder = order
    row.Parent = parent
    rounded(row, 9)
    stroke(row, C.border, 1, 0)

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -70, 0, 18)
    nameLbl.Position = UDim2.new(0, 16, 0, 14)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = labelText
    nameLbl.TextColor3 = C.white
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 13
    nameLbl.ZIndex = 145
    nameLbl.Parent = row

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -70, 0, 14)
    descLbl.Position = UDim2.new(0, 16, 0, 36)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = descText
    descLbl.TextColor3 = C.dim
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 11
    descLbl.ZIndex = 145
    descLbl.Parent = row

    local trackW, trackH = 50, 26
    local trackBg = Instance.new("Frame")
    trackBg.Size = UDim2.fromOffset(trackW, trackH)
    trackBg.Position = UDim2.new(1, -(trackW + 14), 0.5, -trackH / 2)
    trackBg.BackgroundColor3 = defaultVal and Color3.fromRGB(200, 200, 200) or C.surface3
    trackBg.BorderSizePixel = 0
    trackBg.ZIndex = 145
    trackBg.Parent = row
    rounded(trackBg, trackH)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(trackH - 4, trackH - 4)
    knob.Position = UDim2.new(defaultVal and 1 or 0, defaultVal and -((trackH - 4) + 2) or 2, 0.5, -(trackH - 4) / 2)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 146
    knob.Parent = trackBg
    rounded(knob, trackH)

    local togBtn = Instance.new("TextButton")
    togBtn.Size = UDim2.new(1, 0, 1, 0)
    togBtn.BackgroundTransparency = 1
    togBtn.Text = ""
    togBtn.ZIndex = 147
    togBtn.Parent = row

    local togState = defaultVal
    togBtn.MouseButton1Click:Connect(function()
        togState = not togState
        TweenService:Create(trackBg, TweenInfo.new(0.18), {
            BackgroundColor3 = togState and Color3.fromRGB(200, 200, 200) or C.surface3
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(togState and 1 or 0, togState and -((trackH - 4) + 2) or 2, 0.5, -(trackH - 4) / 2)
        }):Play()
        if onChanged then onChanged(togState) end
    end)

    return row
end

local noTexBtn = Instance.new("Frame")
noTexBtn.Size = UDim2.new(1, 0, 0, 68)
noTexBtn.BackgroundColor3 = C.surface
noTexBtn.BorderSizePixel = 0
noTexBtn.ZIndex = 144
noTexBtn.LayoutOrder = 0
noTexBtn.Parent = settingsScroll
rounded(noTexBtn, 9)
stroke(noTexBtn, C.border, 1, 0)

local noTexName = Instance.new("TextLabel")
noTexName.Size = UDim2.new(1, -160, 0, 18)
noTexName.Position = UDim2.new(0, 14, 0, 10)
noTexName.BackgroundTransparency = 1
noTexName.Text = "Force No Texture"
noTexName.TextColor3 = C.white
noTexName.TextXAlignment = Enum.TextXAlignment.Left
noTexName.Font = Enum.Font.GothamBold
noTexName.TextSize = 15
noTexName.ZIndex = 145
noTexName.Parent = noTexBtn

local noTexDesc = Instance.new("TextLabel")
noTexDesc.Size = UDim2.new(1, -160, 0, 14)
noTexDesc.Position = UDim2.new(0, 14, 0, 30)
noTexDesc.BackgroundTransparency = 1
noTexDesc.Text = "No FFlag - Script-based texture removal"
noTexDesc.TextColor3 = C.dim
noTexDesc.TextXAlignment = Enum.TextXAlignment.Left
noTexDesc.Font = Enum.Font.Gotham
noTexDesc.TextSize = 15
noTexDesc.ZIndex = 145
noTexDesc.Parent = noTexBtn

local noTexRunBtn = Instance.new("TextButton")
noTexRunBtn.Size = UDim2.fromOffset(130, 28)
noTexRunBtn.Position = UDim2.new(1, -144, 0.5, -14)
noTexRunBtn.BackgroundColor3 = C.surface2
noTexRunBtn.Text = "No Texture"
noTexRunBtn.TextColor3 = C.white
noTexRunBtn.Font = Enum.Font.GothamBold
noTexRunBtn.TextSize = 13
noTexRunBtn.AutoButtonColor = false
noTexRunBtn.BorderSizePixel = 0
noTexRunBtn.ZIndex = 146
noTexRunBtn.Parent = noTexBtn
rounded(noTexRunBtn, 7)
stroke(noTexRunBtn, C.border, 1, 0)
btnFx(noTexRunBtn, Color3.fromRGB(32, 32, 32))

local noTexActive = false
local savedTextures = {}
local noTexConnection
noTexRunBtn.MouseButton1Click:Connect(function()
    noTexActive = not noTexActive
    if noTexActive then
        noTexRunBtn.Text = "Restore"
        noTexRunBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
        noTexRunBtn.TextColor3 = Color3.fromRGB(10, 10, 10)
        savedTextures = {}
        
        local function removeTextures(v)
            if v:IsA("Texture") or v:IsA("Decal") then
                local ok, oldT = pcall(function() return v.Transparency end)
                if ok and oldT ~= 1 then
                    savedTextures[v] = {type="tex", transparency=oldT}
                    pcall(function() v.Transparency = 1 end)
                end
            elseif v:IsA("SpecialMesh") then
                local ok, oldId = pcall(function() return v.TextureId end)
                if ok and oldId ~= "" then
                    savedTextures[v] = {type="mesh", textureId=oldId}
                    pcall(function() v.TextureId = "" end)
                end
            elseif v:IsA("MeshPart") then
                local ok, oldId = pcall(function() return v.TextureID end)
                if ok and oldId ~= "" then
                    savedTextures[v] = {type="meshid", textureId=oldId}
                    pcall(function() v.TextureID = "" end)
                end
            elseif v:IsA("SurfaceAppearance") then
                local ok, cmap = pcall(function() return v.ColorMap end)
                if ok and cmap ~= "" then
                    savedTextures[v] = {type="surf", colormap=cmap}
                    pcall(function() v.ColorMap = "" end)
                end
            elseif v:IsA("BasePart") then
                local ok, oldM = pcall(function() return v.Material end)
                if ok and oldM ~= Enum.Material.SmoothPlastic then
                    savedTextures[v] = {type="mat", mat=oldM}
                    pcall(function() v.Material = Enum.Material.SmoothPlastic end)
                end
            end
        end

        task.spawn(function()
            for _, v in ipairs(workspace:GetDescendants()) do removeTextures(v) end
            for _, v in ipairs(game:GetService("Players"):GetDescendants()) do removeTextures(v) end
        end)
        pcall(function() noTexConnection = workspace.DescendantAdded:Connect(removeTextures) end)
        
        toast("No Texture applied to all objects")
    else
        noTexRunBtn.Text = "No Texture"
        noTexRunBtn.BackgroundColor3 = C.surface2
        noTexRunBtn.TextColor3 = C.white
        if noTexConnection then
            pcall(function() noTexConnection:Disconnect() end)
            noTexConnection = nil
        end
        task.spawn(function()
            for obj, data in pairs(savedTextures) do
                if data.type == "tex" then pcall(function() obj.Transparency = data.transparency end)
                elseif data.type == "mesh" then pcall(function() obj.TextureId = data.textureId end)
                elseif data.type == "meshid" then pcall(function() obj.TextureID = data.textureId end)
                elseif data.type == "surf" then pcall(function() obj.ColorMap = data.colormap end)
                elseif data.type == "mat" then pcall(function() obj.Material = data.mat end)
                end
            end
            savedTextures = {}
        end)
        toast("Textures restored")
    end
end)

makeToggleRow(settingsScroll, "Notifications", "Show in-UI toast notifications", true, 1, function(state)
    settingsState.notifications = state
    toast(state and "Notifications enabled" or "Notifications disabled")
end)

makeToggleRow(settingsScroll, "Auto Rejoin", "Automatically rejoin on disconnect", false, 2, function(state)
    settingsState.autoRejoin = state
    toast(state and "Auto Auto Rejoin enabled" or "Auto Auto Rejoin disabled")
end)

makeToggleRow(settingsScroll, "Reapply on Teleport", "Reapply flags after teleport", false, 3, function(state)
    settingsState.reapply = state
    toast(state and "Reapply enabled" or "Reapply disabled")
end)

settingsScroll.CanvasSize = UDim2.new(0, 0, 0, 56 * 4 + 8 * 3 + 16)

local aboutSection = sections["about"]

local aboutScroll = Instance.new("ScrollingFrame")
aboutScroll.Size = UDim2.new(1, -PAD * 2, 1, -10)
aboutScroll.Position = UDim2.new(0, PAD, 0, 8)
aboutScroll.BackgroundTransparency = 1
aboutScroll.BorderSizePixel = 0
aboutScroll.ScrollBarThickness = 4
aboutScroll.ScrollBarImageColor3 = C.border
aboutScroll.ZIndex = 143
aboutScroll.Parent = aboutSection

local aboutLayout = Instance.new("UIListLayout")
aboutLayout.FillDirection = Enum.FillDirection.Vertical
aboutLayout.SortOrder = Enum.SortOrder.LayoutOrder
aboutLayout.Padding = UDim.new(0, 10)
aboutLayout.Parent = aboutScroll

local aboutPad = Instance.new("UIPadding")
aboutPad.PaddingTop = UDim.new(0, 4)
aboutPad.PaddingBottom = UDim.new(0, 12)
aboutPad.Parent = aboutScroll

local heroCard = Instance.new("Frame")
heroCard.Size = UDim2.new(1, 0, 0, 120)
heroCard.BackgroundColor3 = C.surface
heroCard.BorderSizePixel = 0
heroCard.ZIndex = 144
heroCard.LayoutOrder = 0
heroCard.Parent = aboutScroll
rounded(heroCard, 12)
stroke(heroCard, C.border, 1, 0)

local heroLogoImg = Instance.new("ImageLabel")
heroLogoImg.Size = UDim2.fromOffset(60, 60)
heroLogoImg.Position = UDim2.new(0.5, -25, 0, 10)
heroLogoImg.BackgroundTransparency = 1
heroLogoImg.Image = "rbxassetid://136293924276809"
heroLogoImg.ScaleType = Enum.ScaleType.Fit
heroLogoImg.ZIndex = 145
heroLogoImg.Parent = heroCard

local heroTitle = Instance.new("TextLabel")
heroTitle.Size = UDim2.new(1, 0, 0, 18)
heroTitle.Position = UDim2.new(0, 0, 0, 75)
heroTitle.BackgroundTransparency = 1
heroTitle.Text = "Vaystrap Mobile V1.0.0 Beta"
heroTitle.TextColor3 = C.white
heroTitle.Font = Enum.Font.GothamBold
heroTitle.TextSize = 14
heroTitle.ZIndex = 145
heroTitle.Parent = heroCard

local heroDesc = Instance.new("TextLabel")
heroDesc.Size = UDim2.new(1, -20, 0, 14)
heroDesc.Position = UDim2.new(0, 10, 0, 96)
heroDesc.BackgroundTransparency = 1
heroDesc.Text = "Best fflag injector for Mobile"
heroDesc.TextColor3 = C.dim
heroDesc.Font = Enum.Font.Gotham
heroDesc.TextSize = 12
heroDesc.ZIndex = 145
heroDesc.Parent = heroCard

local madeWithCard = Instance.new("Frame")
madeWithCard.Size = UDim2.new(1, 0, 0, 38)
madeWithCard.BackgroundColor3 = C.surface
madeWithCard.BorderSizePixel = 0
madeWithCard.ZIndex = 144
madeWithCard.LayoutOrder = 1
madeWithCard.Parent = aboutScroll
rounded(madeWithCard, 9)
stroke(madeWithCard, C.border, 1, 0)

local madeWithLbl = Instance.new("TextLabel")
madeWithLbl.Size = UDim2.new(1, -20, 1, 0)
madeWithLbl.Position = UDim2.new(0, 10, 0, 0)
madeWithLbl.BackgroundTransparency = 1
madeWithLbl.Text = "Made with love by Vaystrap Dev Team  *  For the Roblox Android & iOS fflag community"
madeWithLbl.TextColor3 = C.muted
madeWithLbl.Font = Enum.Font.Gotham
madeWithLbl.TextSize = 11
madeWithLbl.TextWrapped = true
madeWithLbl.ZIndex = 145
madeWithLbl.Parent = madeWithCard

local featuresCard = Instance.new("Frame")
featuresCard.Size = UDim2.new(1, 0, 0, 140)
featuresCard.BackgroundColor3 = C.surface
featuresCard.BorderSizePixel = 0
featuresCard.ZIndex = 144
featuresCard.LayoutOrder = 2
featuresCard.Parent = aboutScroll
rounded(featuresCard, 9)
stroke(featuresCard, C.border, 1, 0)

local featTitleLbl = Instance.new("TextLabel")
featTitleLbl.Size = UDim2.new(1, -20, 0, 18)
featTitleLbl.Position = UDim2.new(0, 12, 0, 10)
featTitleLbl.BackgroundTransparency = 1
featTitleLbl.Text = "Features"
featTitleLbl.TextColor3 = C.white
featTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
featTitleLbl.Font = Enum.Font.GothamBold
featTitleLbl.TextSize = 15
featTitleLbl.ZIndex = 145
featTitleLbl.Parent = featuresCard

local FEATURES = {
    "JSON-based FFlag Editor with clipboard paste support",
    "Live FFlag Database with one-click add to editor",
    "Preset library: FPS Boost, Potato Mode, Latency",
    "Script-based Force No Texture (no FFlag required)",
    "Instant server rejoin with TeleportService fallback",
    "Minimal black & white UI with section animations",
    "In-UI toast notifications with bell animation",
    "Auto Rejoin and Reapply toggles",
    "Mobile compatible drag-and-drop window",
}

for fi, feat in ipairs(FEATURES) do
    local fl = Instance.new("TextLabel")
    fl.Size = UDim2.new(1, -24, 0, 13)
    fl.Position = UDim2.new(0, 12, 0, 26 + (fi - 1) * 13)
    fl.BackgroundTransparency = 1
    fl.Text = "* " .. feat
    fl.TextColor3 = C.muted
    fl.TextXAlignment = Enum.TextXAlignment.Left
    fl.Font = Enum.Font.Gotham
    fl.TextSize = 11
    fl.ZIndex = 145
    fl.Parent = featuresCard
end

featuresCard.Size = UDim2.new(1, 0, 0, 32 + #FEATURES * 13)

local devsCard = Instance.new("Frame")
devsCard.Size = UDim2.new(1, 0, 0, 250)
devsCard.BackgroundColor3 = C.surface
devsCard.BorderSizePixel = 0
devsCard.ZIndex = 144
devsCard.LayoutOrder = 3
devsCard.Parent = aboutScroll
rounded(devsCard, 9)
stroke(devsCard, C.border, 1, 0)

local devsTitleLbl = Instance.new("TextLabel")
devsTitleLbl.Size = UDim2.new(1, -20, 0, 18)
devsTitleLbl.Position = UDim2.new(0, 12, 0, 10)
devsTitleLbl.BackgroundTransparency = 1
devsTitleLbl.Text = "Development Team"
devsTitleLbl.TextColor3 = C.white
devsTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
devsTitleLbl.Font = Enum.Font.GothamBold
devsTitleLbl.TextSize = 15
devsTitleLbl.ZIndex = 145
devsTitleLbl.Parent = devsCard

local DEVS = {
    { name = "Vayntz",   role = "Owner",     id = "1086319417761202256" },
}

for di, dev in ipairs(DEVS) do
    local devRow = Instance.new("Frame")
    devRow.Size = UDim2.new(1, -24, 0, 28)
    devRow.Position = UDim2.new(0, 12, 0, 30 + (di - 1) * 32)
    devRow.BackgroundTransparency = 1
    devRow.ZIndex = 145
    devRow.Parent = devsCard

    local avatar = Instance.new("TextLabel")
    avatar.Size = UDim2.fromOffset(28, 28)
    avatar.Position = UDim2.new(0, 0, 0.5, -14)
    avatar.BackgroundColor3 = Color3.fromRGB(math.random(40, 100), math.random(40, 100), math.random(40, 100))
    avatar.Text = dev.name:sub(1,1):upper()
    avatar.TextColor3 = C.pure
    avatar.TextSize = 14
    avatar.Font = Enum.Font.GothamBold
    avatar.BorderSizePixel = 0
    avatar.ZIndex = 146
    avatar.Parent = devRow
    rounded(avatar, 14)

    local avatarImg = Instance.new("ImageLabel")
    avatarImg.Size = UDim2.new(1, 0, 1, 0)
    avatarImg.BackgroundTransparency = 1
    avatarImg.ZIndex = 147
    avatarImg.Parent = avatar
    rounded(avatarImg, 14)
    
    if dev.id then
        pcall(function()
            local rbxId = tonumber(dev.id)
            if rbxId and rbxId < 9000000000 then 
                avatarImg.Image = "rbxthumb://type=AvatarHeadShot&id="..dev.id.."&w=150&h=150"
                avatar.Text = ""
            end
        end)
    end

    local devNameLbl = Instance.new("TextLabel")
    devNameLbl.Size = UDim2.new(0.5, -30, 1, 0)
    devNameLbl.Position = UDim2.new(0, 36, 0, 0)
    devNameLbl.BackgroundTransparency = 1
    devNameLbl.Text = dev.name
    devNameLbl.TextColor3 = C.white
    devNameLbl.TextXAlignment = Enum.TextXAlignment.Left
    devNameLbl.Font = Enum.Font.GothamBold
    devNameLbl.TextSize = 13
    devNameLbl.ZIndex = 146
    devNameLbl.Parent = devRow

    local roleText = dev.role
    if dev.note then
        roleText = roleText .. " - " .. dev.note
    end

    local devRoleLbl = Instance.new("TextLabel")
    devRoleLbl.Size = UDim2.new(0, 120, 1, 0)
    devRoleLbl.Position = UDim2.new(1, -120, 0, 0)
    devRoleLbl.BackgroundTransparency = 1
    devRoleLbl.Text = roleText
    devRoleLbl.TextColor3 = dev.role == "Owner" and C.white or C.dim
    devRoleLbl.TextXAlignment = Enum.TextXAlignment.Right
    devRoleLbl.Font = Enum.Font.Gotham
    devRoleLbl.TextSize = 11
    devRoleLbl.ZIndex = 146
    devRoleLbl.Parent = devRow
end

devsCard.Size = UDim2.new(1, 0, 0, 34 + #DEVS * 32)

local linksCard = Instance.new("Frame")
linksCard.Size = UDim2.new(1, 0, 0, 54)
linksCard.BackgroundColor3 = C.surface
linksCard.BorderSizePixel = 0
linksCard.ZIndex = 144
linksCard.LayoutOrder = 4
linksCard.Parent = aboutScroll
rounded(linksCard, 9)
stroke(linksCard, C.border, 1, 0)

local linksTitleLbl = Instance.new("TextLabel")
linksTitleLbl.Size = UDim2.new(1, -20, 0, 14)
linksTitleLbl.Position = UDim2.new(0, 12, 0, 8)
linksTitleLbl.BackgroundTransparency = 1
linksTitleLbl.Text = "Community Links"
linksTitleLbl.TextColor3 = C.white
linksTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
linksTitleLbl.Font = Enum.Font.GothamBold
linksTitleLbl.TextSize = 14
linksTitleLbl.ZIndex = 145
linksTitleLbl.Parent = linksCard

local LINKS = {
    { label = "Discord", url = "https://discord.gg/hNEYh7sEhd",     svg = SVG_DISCORD },
    { label = "YouTube", url = "https://youtube.com/@vayntz",   svg = SVG_YOUTUBE },
    { label = "GitHub",  url = "https://github.com/Vaystrap",     svg = SVG_GITHUB  },
}

for li, link in ipairs(LINKS) do
    local lb = Instance.new("TextButton")
    lb.Size = UDim2.fromOffset(72, 22)
    lb.Position = UDim2.new(0, 12 + (li - 1) * 80, 0, 24)
    lb.BackgroundColor3 = C.surface2
    lb.Text = link.label
    lb.TextColor3 = C.white
    lb.Font = Enum.Font.GothamMedium
    lb.TextSize = 13
    lb.AutoButtonColor = false
    lb.BorderSizePixel = 0
    lb.ZIndex = 146
    lb.Parent = linksCard
    rounded(lb, 6)
    stroke(lb, C.border, 1, 0)
    btnFx(lb, Color3.fromRGB(32, 32, 32))

    local lurl = link.url
    local llabel = link.label
    lb.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(lurl)
            toast(llabel .. " link copied!")
        else
            toast(llabel .. ": " .. lurl)
        end
    end)
end

aboutScroll.CanvasSize = UDim2.new(0, 0, 0,
    100 + 38 + featuresCard.Size.Y.Offset + devsCard.Size.Y.Offset + 54 + 10 * 5 + 20
)

local miniLogoBtn = Instance.new("TextButton")
miniLogoBtn.Name = "MiniLogo"
miniLogoBtn.Size = UDim2.fromOffset(38, 38)
miniLogoBtn.Position = UDim2.new(0, 8, 0.5, -19)
miniLogoBtn.BackgroundTransparency = 1
miniLogoBtn.Text = ""
miniLogoBtn.AutoButtonColor = false
miniLogoBtn.BorderSizePixel = 0
miniLogoBtn.ZIndex = 50000
miniLogoBtn.Visible = false
miniLogoBtn.Parent = gui

dragWindow(miniLogoBtn, miniLogoBtn)

local miniLogoImg = Instance.new("ImageLabel")
miniLogoImg.Size = UDim2.new(1, 0, 1, 0)
miniLogoImg.BackgroundTransparency = 1
miniLogoImg.Image = "rbxassetid://136293924276809"
miniLogoImg.ScaleType = Enum.ScaleType.Fit
miniLogoImg.ZIndex = 50001
miniLogoImg.Parent = miniLogoBtn
local minimized = false
local maximized = false
local savedSize = UDim2.new(1, 0, 1, 0)
local savedPos = UDim2.new(0, 0, 0, 0)

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = true
    TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.fromOffset(0, 0),
        Position = UDim2.new(
            frame.Position.X.Scale,
            frame.Position.X.Offset + WIN_W / 2,
            frame.Position.Y.Scale,
            frame.Position.Y.Offset + WIN_H / 2
        )
    }):Play()
    task.delay(0.26, function()
        frame.Visible = false
        miniLogoBtn.Visible = true
    end)
end)

maximizeBtn.MouseButton1Click:Connect(function()
    if maximized then
        maximized = false
        maximizeBtn.Text = "⬜"
        TweenService:Create(frame, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = savedSize,
            Position = savedPos
        }):Play()
    else
        savedSize = frame.Size
        savedPos = frame.Position
        maximized = true
        maximizeBtn.Text = "🔲"
        TweenService:Create(frame, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.92, 0, 0.88, 0),
            Position = UDim2.new(0.04, 0, 0.06, 0)
        }):Play()
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    minimized = true
    TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.fromOffset(0, 0),
        Position = UDim2.new(
            frame.Position.X.Scale,
            frame.Position.X.Offset + WIN_W / 2,
            frame.Position.Y.Scale,
            frame.Position.Y.Offset + WIN_H / 2
        )
    }):Play()
    task.delay(0.26, function()
        frame.Visible = false
        miniLogoBtn.Visible = true
    end)
end)

miniLogoBtn.MouseButton1Click:Connect(function()
    miniLogoBtn.Visible = false
    minimized = false
    frame.Visible = true
    frame.Size = UDim2.fromOffset(0, 0)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)

    miniLogoBtn.Rotation = 0

    task.delay(0.1, function()
        TweenService:Create(frame, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = savedSize,
            Position = savedPos
        }):Play()
    end)
end)

UIS.InputBegan:Connect(function(input, chat)
    if chat then return end
    if input.KeyCode == Enum.KeyCode.K then
        if minimized then
            miniLogoBtn.Visible = false
            minimized = false
            frame.Visible = true
            frame.Size = UDim2.fromOffset(0, 0)
            frame.Position = UDim2.new(0.5, 0, 0.5, 0)
            TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = savedSize,
                Position = savedPos
            }):Play()
        else
            frame.Visible = not frame.Visible
        end
    end
end)

local loadingOverlay = Instance.new("Frame")
loadingOverlay.Size = UDim2.new(1, 0, 1, 0)
loadingOverlay.BackgroundTransparency = 1
loadingOverlay.ZIndex = 99000
loadingOverlay.Visible = true
loadingOverlay.Parent = gui

local loadingInner = Instance.new("Frame")
loadingInner.Size = UDim2.fromOffset(WIN_W, WIN_H)
loadingInner.Position = UDim2.new(0.5, -WIN_W / 2, 0.5, -WIN_H / 2)
loadingInner.BackgroundColor3 = C.bg
loadingInner.BorderSizePixel = 0
loadingInner.ZIndex = 99001
loadingInner.Parent = loadingOverlay
rounded(loadingInner, 14)
stroke(loadingInner, C.border, 1, 0)

local spinLogoHolder = Instance.new("Frame")
spinLogoHolder.Size = UDim2.fromOffset(56, 56)
spinLogoHolder.Position = UDim2.new(0.5, -28, 0.5, -70)
spinLogoHolder.BackgroundTransparency = 1
spinLogoHolder.ZIndex = 99002
spinLogoHolder.Parent = loadingInner

local spinLogoImg = Instance.new("ImageLabel")
spinLogoImg.Size = UDim2.new(1, 0, 1, 0)
spinLogoImg.BackgroundTransparency = 1
spinLogoImg.Image = "rbxassetid://136293924276809"
spinLogoImg.ScaleType = Enum.ScaleType.Fit
spinLogoImg.ZIndex = 99003
spinLogoImg.Parent = spinLogoHolder
local loadingTitleLbl = Instance.new("TextLabel")
loadingTitleLbl.Size = UDim2.new(1, 0, 0, 22)
loadingTitleLbl.Position = UDim2.new(0, 0, 0.5, 2)
loadingTitleLbl.BackgroundTransparency = 1
loadingTitleLbl.Text = "Loading Vaystrap"
loadingTitleLbl.TextColor3 = C.white
loadingTitleLbl.Font = Enum.Font.GothamBold
loadingTitleLbl.TextSize = 15
loadingTitleLbl.ZIndex = 99002
loadingTitleLbl.Parent = loadingInner

local barTrack = Instance.new("Frame")
barTrack.Size = UDim2.new(0, 220, 0, 3)
barTrack.Position = UDim2.new(0.5, -110, 0.5, 36)
barTrack.BackgroundColor3 = C.surface2
barTrack.BorderSizePixel = 0
barTrack.ZIndex = 99002
barTrack.Parent = loadingInner
rounded(barTrack, 4)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
barFill.BorderSizePixel = 0
barFill.ZIndex = 99003
barFill.Parent = barTrack
rounded(barFill, 4)

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120)),
})
grad.Rotation = 0
grad.Parent = barFill

local dots = 0
task.spawn(function()
    while loadingOverlay.Visible do
        dots = (dots % 3) + 1
        loadingTitleLbl.Text = "Loading Vaystrap" .. string.rep(".", dots)
        task.wait(0.22)
    end
end)

TweenService:Create(barFill, TweenInfo.new(2.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
    Size = UDim2.new(1, 0, 1, 0)
}):Play()

task.delay(3, function()
    TweenService:Create(loadingInner, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(loadingTitleLbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(spinLogoImg, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
    TweenService:Create(barTrack, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(barFill, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()

    task.delay(0.42, function()
        loadingOverlay.Visible = false
        frame.Visible = true

        if hasGroupTransparency(frame) then
            frame.GroupTransparency = 1
            frame.Position = UDim2.new(
                0.5, -WIN_W / 2,
                0.5, -WIN_H / 2 + 18
            )
            TweenService:Create(frame, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                GroupTransparency = 0,
                Position = UDim2.new(0.5, -WIN_W / 2, 0.5, -WIN_H / 2)
            }):Play()
        end

        switchSection("editor")
        task.delay(0.5, function()
            toast("Vaystrap loaded successfully")
        end)
    end)
end)
