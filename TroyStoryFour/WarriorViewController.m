//
//  ViewController.m
//  TroyStoryFour
//
//  Created by Matt Larkin on 3/31/15.
//  Copyright (c) 2015 Matt Larkin. All rights reserved.
//

#import "WarriorViewController.h"
#import "AppDelegate.h"

@interface WarriorViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *warriorTableView;
@property NSManagedObjectContext *moc;
@property NSArray *warriors;
@property BOOL toggled;

@end

@implementation WarriorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.moc = appDelegate.managedObjectContext;


}

-(IBAction)addWarrior:(UITextField *)sender
{
    NSManagedObject *warrior = [NSEntityDescription insertNewObjectForEntityForName:@"Warrior"  inManagedObjectContext:self.moc];
    int rand = arc4random()%10;

    [warrior setValue:sender.text forKey:@"name"];
    [warrior setValue:[NSNumber numberWithInt:rand] forKey:@"prowess"];
    [self.moc save:nil];
    [self load];
     sender.text = @"";
    [sender resignFirstResponder];

}

-(IBAction)prowessToggle:(UIButton *)sender
{

    self.toggled = !self.toggled;
    [self load];

}


/**
 *  Fetches Objects from Database
 */
-(void)load {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Warrior"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *sortDescriptortwo = [[NSSortDescriptor alloc] initWithKey:@"prowess" ascending:YES];


    if (self.toggled) {
        
    request.predicate = [NSPredicate predicateWithFormat:@"prowess <= 5"];
    }
        else
    {
        request.predicate = [NSPredicate predicateWithFormat:@"prowess >=5"];
    }


    request.sortDescriptors = @[sortDescriptor, sortDescriptortwo];


     self.warriors = [self.moc executeFetchRequest:request error:nil];
    [self.warriorTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.warriors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *warrior = self.warriors[indexPath.row];
    UITableViewCell *cell = [_warriorTableView dequeueReusableCellWithIdentifier:@"CellID"];
    cell.textLabel.text = [warrior valueForKey:@"name"];
    cell.detailTextLabel.text = [[warrior valueForKey:@"prowess"]stringValue];
    return cell;
}

@end
