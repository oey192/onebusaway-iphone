#import "OBARequestDrivenTableViewController.h"
#import "OBAVehicleStatusV2.h"

NS_ASSUME_NONNULL_BEGIN

@interface OBAVehicleDetailsController : OBARequestDrivenTableViewController
- (id) initWithVehicleId:(NSString*)vehicleId;
@end

NS_ASSUME_NONNULL_END