//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager;

import robotlegs.bender.extensions.viewManager.impl.ContainerRegistry;
import robotlegs.bender.extensions.viewManager.impl.ManualStageObserver;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.api.ILogger;

/**
 * This extension install a manual Stage Observer
 */

@:keepSub
class ManualStageObserverExtension implements IExtension
{

	/*============================================================================*/
	/* Private Static Properties                                                  */
	/*============================================================================*/

	// Really? Yes, there can be only one.
	private static var _manualStageObserver:ManualStageObserver;

	private static var _installCount:UInt;

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _injector:IInjector;

	private var _logger:ILogger;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function extend(context:IContext):Void
	{
		context.whenInitializing(whenInitializing);
		context.whenDestroying(whenDestroying);
		_installCount++;
		_injector = context.injector;
		_logger = context.getLogger(this);
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function whenInitializing():Void
	{
		// Hark, an actual Singleton!
		if (_manualStageObserver == null)
		{
			var containerRegistry:ContainerRegistry = _injector.getInstance(ContainerRegistry);
			_logger.debug("Creating genuine ManualStageObserver Singleton");
			_manualStageObserver = new ManualStageObserver(containerRegistry);
		}
	}

	private function whenDestroying():Void
	{
		_installCount--;
		if (_installCount == 0)
		{
			_logger.debug("Destroying genuine ManualStageObserver Singleton");
			_manualStageObserver.destroy();
			_manualStageObserver = null;
		}
	}
}