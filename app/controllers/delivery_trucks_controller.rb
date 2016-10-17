class DeliveryTrucksController < ApplicationController
  before_action :set_delivery_truck, only: [:show, :edit, :update, :destroy]

  # GET /delivery_trucks
  # GET /delivery_trucks.json
  def index
    @delivery_trucks = DeliveryTruck.all
    @myVehicles = Vehicle.where("truckId LIKE ?", params[:id])
    
  end 

  # GET /delivery_trucks/1
  # GET /delivery_trucks/1.json
  def show
    set_delivery_truck
    @myVehicles = Vehicle.where("truckId LIKE ?", params[:id])
    @waypoints = Array.new
    @origin = @delivery_truck.origin
    @destination = Array.new
    @distances = Array.new
    @directions = Array.new

    @myVehicles.each do |vehicle|
      ##Include only one of each destination 
      if vehicle.origin == @delivery_truck.origin or @waypoints.include? vehicle.origin
      else
        @waypoints.push(vehicle.origin)
      end
      if vehicle.destination == @delivery_truck.origin or @waypoints.include? vehicle.destination
      else
        @waypoints.push(vehicle.destination)
      end
    end

      ###Find furthest point for destination
      @waypoints.each do |wp|
        @directions.push GoogleDirections.new(@delivery_truck.origin, wp)
        @distances.push (@directions.last.distance_in_miles)
      end
      if @directions.any?
      @destination = @waypoints[@distances.index(@distances.max)]
      @waypoints.delete_at(@distances.index(@distances.max))
    end

  end
  # GET /delivery_trucks/new
  def new
    @delivery_truck = DeliveryTruck.new
  end

  # GET /delivery_trucks/1/edit
  def edit
  end

  # POST /delivery_trucks
  # POST /delivery_trucks.json
  def create
    @delivery_truck = DeliveryTruck.new(delivery_truck_params)

    respond_to do |format|
      if @delivery_truck.save
        format.html { redirect_to @delivery_truck, notice: 'Delivery truck was successfully created.' }
        format.json { render :show, status: :created, location: @delivery_truck }
      else
        format.html { render :new }
        format.json { render json: @delivery_truck.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /delivery_trucks/1
  # PATCH/PUT /delivery_trucks/1.json
  def update
    respond_to do |format|
      if @delivery_truck.update(delivery_truck_params)
        format.html { redirect_to @delivery_truck, notice: 'Delivery truck was successfully updated.' }
        format.json { render :show, status: :ok, location: @delivery_truck }
      else
        format.html { render :edit }
        format.json { render json: @delivery_truck.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /delivery_trucks/1
  # DELETE /delivery_trucks/1.json
  def destroy
    @delivery_truck.destroy
    respond_to do |format|
      format.html { redirect_to delivery_trucks_url, notice: 'Delivery truck was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_delivery_truck
    @delivery_truck = DeliveryTruck.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def delivery_truck_params
    params.require(:delivery_truck).permit(:name, :minimumPossibleWeight, :maximumPossibleWeight, :vinNumber, :origin, :destination, :yearManufactured, :make, :model, :payloadEmptyWeight, :originLocation, :currentLocation, :destinationLocation, :weightCapacity, :yearAquired, :carFax, :maintenanceHistory, :nextMaintenance, :highwayMPG, :cityMPG, :avgMPG, :scheduledDepartureTime, :estimatedArrivalTime, :requestedArrivalTime, :image)
  end
end
