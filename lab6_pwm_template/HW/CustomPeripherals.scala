package freechips.rocketchip.devices.tilelink

import Chisel._
import freechips.rocketchip.subsystem._ //BaseSubsystem
import freechips.rocketchip.config.{Parameters, Field}
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.regmapper.{HasRegMap, RegField}
import freechips.rocketchip.tilelink._
import freechips.rocketchip.util.UIntIsOneOf


/*******************************/
/*                             */
/*                             */
/*     Single Peripherals      */    
/*      Implementations        */
/*                             */
/*                             */
/*******************************/

/*******************************/
/*            PWM              */
/*******************************/
class PWMModule(w: Int) extends Module {
  val io = IO(new Bundle {
    val pwmout  = Bool(OUTPUT)
    val period  = UInt(INPUT, width = w)
    val duty    = UInt(INPUT, width = w)
    val status  = Bool(OUTPUT)
    val enable  = Bool(INPUT)
  })

  // The counter should count up until period is reached
  val pwmcounter = Reg(UInt(w.W))

  when (io.enable && (pwmcounter < io.period - 1.U )  ){
    pwmcounter := pwmcounter + 1.U
  }.otherwise {
    pwmcounter := 0.U
  }

  // If PWM is enabled, pwmout is high when counter < duty
  // If PWM is not enabled, it will always be low
  io.pwmout := io.enable && (pwmcounter < io.duty)
  io.status := io.enable
}


/*******************************/
/*        BlackBoxModule       */
/*******************************/
class BlackBoxModule(w: Int) extends Module{
  val io = new Bundle {
    val clock    = Clock(INPUT)
    val reset  = Bool(INPUT)
    val a = UInt(INPUT, w)
    val b = UInt(INPUT, w)
    val s = UInt(OUTPUT, w)
  }
  val blackbox = Module(new blackbox(32)).connect(io.clock,io.reset,io.a,io.b,io.s) 
}

class blackbox(w: Int) extends BlackBox {
  val io = new Bundle {
    val clock = Clock(INPUT)
    val reset = Bool(INPUT)
    val a = UInt(INPUT, w)
    val b = UInt(INPUT, w)
    val s = UInt(OUTPUT, w)
  }

  def connect(c: Clock, r: Bool, a: UInt, b: UInt, s: UInt) = {
    io.clock := c
    io.reset := r
    io.a := a
    io.b := b
    s := io.s
  }
}

/*********************************/
/*           Counter             */
/*********************************/
class CounterModule(w: Int) extends Module {
  val io = IO(new Bundle {
    val enable     = Bool(INPUT)
    val CounterLoad  = UInt(INPUT, w)
    val CounterOut    = Bool(OUTPUT)
    val CounterValue = UInt(OUTPUT, width = w)
    
    /* Interrupts */
    val CounterINT0  = Bool(OUTPUT)
    val CounterINT1  = Bool(OUTPUT)
    val CounterINT2  = Bool(OUTPUT)
    val CounterINT3  = Bool(OUTPUT)

    /* Interrupt enable */
    val CounterIntEnable = UInt(INPUT, width = w)
  })
  // aux variables 
  val auxCounterLoad = Reg(UInt(0, w))

  when (io.enable && (auxCounterLoad =/= UInt(0))) {
    auxCounterLoad := auxCounterLoad - UInt(1)
  } 
  .elsewhen (io.enable && (auxCounterLoad === UInt(0))) {
    io.CounterOut := Bool(true)
  }
  .otherwise {
    io.CounterOut   := Bool(false)
    auxCounterLoad := io.CounterLoad
  }

  io.CounterValue := auxCounterLoad

  /* Interrupts uses the timeout and CounterIntEnable  * 
   * each bit in CounterIntEnable enable resp. int src */
  io.CounterINT0 := io.CounterOut && (io.CounterIntEnable(UInt(0)))
  io.CounterINT1 := io.CounterOut && (io.CounterIntEnable(UInt(1)))
  io.CounterINT2 := io.CounterOut && (io.CounterIntEnable(UInt(2)))
  io.CounterINT3 := io.CounterOut && (io.CounterIntEnable(UInt(3)))
}

/*******************************/
/*     Another Peripheral      */
/*******************************/


/*******************************/
/*                             */
/*                             */
/*          TopLevel           */
/*      CustomPeripherals      */    
/*                             */
/*                             */
/*******************************/
case class CustomPeripheralsParams(
  address  : BigInt, 
  beatBytes: Int)

class CustomPeripheralsBase(w: Int) extends Module {
  val io = IO(new Bundle {
    /* PWM Interface */
    val pwm = new Bundle {
      val pwmout  = Bool(OUTPUT) 
      val period  = UInt(INPUT, width = w)
      val duty    = UInt(INPUT, width = w)
      val status  = Bool(OUTPUT)
      val enable  = Bool(INPUT)
    }

    /* Counter Interface */
    val counter = new Bundle {
      val enable     = Bool(INPUT)
      val CounterLoad  = UInt(INPUT, width = w)
      val CounterOut    = Bool(OUTPUT)
      val CounterValue = UInt(OUTPUT, width = w)
      
      /* Interrupts */
      val CounterINT0  = Bool(OUTPUT)
      val CounterINT1  = Bool(OUTPUT)
      val CounterINT2  = Bool(OUTPUT)
      val CounterINT3  = Bool(OUTPUT)
      val CounterIntEnable = UInt(INPUT, width = w)
    }

    /* BlackBoxModule Interface */
    val blackboxmod = new Bundle {
      val clock    = Clock(INPUT)
      val reset  = Bool(INPUT)
      val a = UInt(INPUT, w)
      val b = UInt(INPUT, w)
      val s = UInt(OUTPUT, w)
    }

    /* Another Module Interface */

  })

  /* PWM */
  val pwm = Module(new PWMModule(32))
  io.pwm.pwmout := pwm.io.pwmout
  io.pwm.status := pwm.io.status

  pwm.io.period := io.pwm.period  
  pwm.io.duty   := io.pwm.duty   
  pwm.io.enable := io.pwm.enable 


  /* Counter */
  val counter = Module(new CounterModule(32))
  io.counter.CounterOut := counter.io.CounterOut
  io.counter.CounterValue := counter.io.CounterValue
  io.counter.CounterINT0 := counter.io.CounterINT0
  io.counter.CounterINT1 := counter.io.CounterINT1
  io.counter.CounterINT2 := counter.io.CounterINT2
  io.counter.CounterINT3 := counter.io.CounterINT3

  counter.io.enable := io.counter.enable
  counter.io.CounterLoad := io.counter.CounterLoad
  counter.io.CounterIntEnable := io.counter.CounterIntEnable


  /* BlackBoxMod */
  val blackboxmod = Module(new BlackBoxModule(32))
  blackboxmod.io.clock := clock
  blackboxmod.io.reset := reset

  io.blackboxmod.s := blackboxmod.io.s

  blackboxmod.io.a := io.blackboxmod.a
  blackboxmod.io.b := io.blackboxmod.b

  /* Another Module */ 
}

/*******************************/
/*                             */
/*                             */
/*          TopLevel           */
/*      External Signals       */    
/*                             */
/*                             */
/*******************************/
trait CustomPeripheralsTLBundle extends Bundle {
  /* PWM */
  val io_pwm_pwmout = Bool(OUTPUT)

  /* Another Module */
}

/*******************************/
/*                             */
/*                             */
/*          TopLevel           */
/*      Registers Mapping      */    
/*                             */
/*                             */
/*******************************/
trait CustomPeripheralsTLModule extends HasRegMap  {
  implicit val p: Parameters
  val io: CustomPeripheralsTLBundle
  def params: CustomPeripheralsParams

  /**************************/
  /* CustomPeripherals Base */
  /**************************/
  val base = Module(new CustomPeripheralsBase(32))

  /***************/
  /* PWM Signals */
  /***************/
  val pwm_period  = Reg(UInt(32.W))
  val pwm_duty    = Reg(UInt(32.W))
  val pwm_enable  = RegInit(false.B)
  val pwm_status  = Reg(UInt(1.W))

  // Outputs
  io.io_pwm_pwmout := base.io.pwm.pwmout
  
  // Inputs
  pwm_status := base.io.pwm.status
  base.io.pwm.period := pwm_period
  base.io.pwm.duty   := pwm_duty
  base.io.pwm.enable := pwm_enable


  /*****************/
  /* Counter Signals */
  /*****************/
  val counter_enable     = RegInit(false.B)
  val counter_CounterLoad  = Reg(UInt(32.W))
  val counter_CounterOut    = Reg(UInt(1.W))
  val counter_CounterValue = Reg(UInt(32.W))
  val counter_CounterIntEnable = Reg(UInt(32.W))

  // Outputs
  counter_CounterOut := base.io.counter.CounterOut
  counter_CounterValue := base.io.counter.CounterValue
 
  // Inputs
  base.io.counter.enable := counter_enable
  base.io.counter.CounterLoad := counter_CounterLoad
  base.io.counter.CounterIntEnable := counter_CounterIntEnable
  
  // interrupts
  interrupts(0) := base.io.counter.CounterINT0
  interrupts(1) := base.io.counter.CounterINT1
  interrupts(2) := base.io.counter.CounterINT2
  interrupts(3) := base.io.counter.CounterINT3


  /************************/
  /* BlackBloxMod Signals */
  /************************/
  val blackboxmod_a = Reg(UInt(32.W))
  val blackboxmod_b = Reg(UInt(32.W))
  val blackboxmod_s = Reg(UInt(32.W))

  // Outputs
  blackboxmod_s := base.io.blackboxmod.s

  // Inputs
  base.io.blackboxmod.a := blackboxmod_a 
  base.io.blackboxmod.b := blackboxmod_b

  /******************/
  /* Module Signals */
  /******************/
  
  /**************************/
  /*      Register Map      */
  /**************************/
  regmap(
    /* PWM */
    0x00 -> Seq(
      RegField(32, pwm_period)),
    0x04 -> Seq(
      RegField(32, pwm_duty)),
    0x08 -> Seq(
      RegField(1, pwm_enable)),
    0x0C -> Seq(
      RegField(1, pwm_status)),

    /* Counter */
    0x10 -> Seq(
      RegField(1, counter_enable)),
    0x14 -> Seq(
      RegField(32, counter_CounterLoad)),
    0x18 -> Seq(
      RegField(1, counter_CounterOut)),
    0x1C -> Seq(
      RegField(32, counter_CounterValue)),
    0x20 -> Seq(
      RegField(32, counter_CounterIntEnable)),

    /* BlackBoxMod */
    0x24 -> Seq(
      RegField(32, blackboxmod_a)),
    0x28 -> Seq(
      RegField(32, blackboxmod_b)),
    0x2C -> Seq(
      RegField(32, blackboxmod_s))

    /* Another Module */
  )
}

/***********************************/
/* Encapsulation in TileLink       */
/*  * explicit use of Interruption */
/***********************************/
class CustomPeripheralsTL(c: CustomPeripheralsParams)(implicit p: Parameters)
  extends TLRegisterRouter(
    c.address, "customperipherals", Seq("ucbbar,customperipherals"), interrupts = 4, beatBytes = c.beatBytes)(
      new TLRegBundle(c, _) with CustomPeripheralsTLBundle)(
      new TLRegModule(c, _, _) with CustomPeripheralsTLModule)

trait HasPeripheryCustomPeripherals { this: BaseSubsystem =>
  implicit val p: Parameters

  private val address  = 0x2000
  private val portName = "customperipherals"

  // LazyModule
  //  * create and conects diferents nodes to make "requests"
  //  * others modules also make "requests" with their nodes
  //  * "requests" are resolved when LazyModule is realized with a .module
  val customperipherals = LazyModule(new CustomPeripheralsTL(CustomPeripheralsParams(address, pbus.beatBytes))(p))
    
  // TileLink node: pbus
  pbus.toVariableWidthSlave(Some(portName)) { customperipherals.node }
  
  // TileLink node: ibus (interrupt bus)   
  // (remember set numbers of interrupts in CustomPeripheralsTLs)
  ibus.fromSync := customperipherals.intnode
}

// LazyModuleImp
//  * is approximately like Chisel Modules
//  * interface to transport signals for top-level (dut.pwm_pwmout)
trait HasPeripheryCustomPeripheralsModuleImp extends LazyModuleImp {
  val outer: HasPeripheryCustomPeripherals

  // PWM Externes Signals avaiable in top-level
  val pwm_pwmout = IO(Bool(OUTPUT))
  pwm_pwmout := outer.customperipherals.module.io.io_pwm_pwmout
  
  // Another Module
}